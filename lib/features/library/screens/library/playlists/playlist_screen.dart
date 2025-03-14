import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:maestro/features/library/screens/library/playlists/widgets/action_icons_widget.dart';
import 'package:maestro/utils/constants/app_images.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import '../../../../../api/apis.dart';
import '../../../../../common/widgets/app_bar/app_bar.dart';
import '../../../../../routes/custom_page_route.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../home/screens/home_screen.dart';
import '../../../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../../profile_settings_screen.dart';

class PlaylistsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> playlists;
  final int initialIndex;

  const PlaylistsScreen({super.key, required this.initialIndex, required this.playlists});

  @override
  State<PlaylistsScreen> createState() => PlaylistsScreenState();
}

class PlaylistsScreenState extends State<PlaylistsScreen> {
  late Future<Map<String, dynamic>?> userDataFuture;
  late TextEditingController _searchController;
  final GetStorage _storageBox = GetStorage();
  late final int selectedIndex;
  bool isShuffleActive = false;
  bool isSearching = false;
  List<String> playlistSuggestions = List.generate(5, (index) => 'Playlist suggestion #${index + 1}');

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    userDataFuture = APIs.fetchUserData();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleShuffle() {
    setState(() {
      isShuffleActive = !isShuffleActive;
    });
    _storageBox.write('isShuffleActive', isShuffleActive);
  }

  String formatReleaseDate(dynamic releaseDate) {
    if (releaseDate != null && releaseDate is Timestamp) {
      try {
        final date = releaseDate.toDate();
        timeago.setLocaleMessages('ru_short', timeago.RuShortMessages());
        return '${timeago.format(date, locale: 'ru_short')} назад';
      } catch (e) {
        return 'Invalid date format';
      }
    } else {
      return 'Date not available';
    }
  }

  Future<void> _reloadData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  void _refreshSuggestions() {
    setState(() {
      playlistSuggestions = List.generate(5, (index) => 'Playlist suggestion #${index + 1}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: const Text('Playlist', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cast, size: 22, color: AppColors.grey),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }
          final userData = snapshot.data!;

          return MiniPlayerManager(
            hideMiniPlayerOnSplash: false,
            child: ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: RefreshIndicator(
                onRefresh: _reloadData,
                displacement: 0,
                color: AppColors.primary,
                backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.softGrey,
                child: ListView.builder(
                  itemCount: widget.playlists.length,
                  itemBuilder: (context, index) {
                    final playlist = widget.playlists[index];

                    if (widget.playlists.isEmpty) {
                      return const Center(child: Text('No playlists available'));
                    }

                    return Column(
                      children: [
                        _buildPlaylists(playlist, userData),
                        ActionIconsWidget(playlists: widget.playlists, index: index, isShuffleActive: isShuffleActive, toggleShuffle: _toggleShuffle),
                        _buildSuggestionNewPlaylist(context),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: (index) {
          Navigator.pushReplacement(context, createPageRoute(HomeScreen(initialIndex: index)));
        },
      ),
    );
  }

  Widget _buildPlaylists(Map<String, dynamic> playlist, Map<String, dynamic> userData) {
    final userImage = userData['image'] as String?;

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 8, top: 12, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              playlist['coverImage'] != null
                ? GestureDetector(
                    onTap: () => _showImageDialog(context, playlist),
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.darkGrey, width: 0.8)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          playlist['coverImage'],
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : const Icon(Icons.music_note, size: 50, color: AppColors.grey),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(playlist['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeLg)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Text('Playlist · ${formatReleaseDate(playlist['releaseDate'])}', style: TextStyle(fontSize: AppSizes.fontSizeSm)),
                            playlist['isPublic'] == false
                              ? Padding(
                                padding: const EdgeInsets.only(left: 6, top: 3),
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(color: AppColors.grey, shape: BoxShape.circle),
                                  child: Icon(Icons.lock, size: 13, color: AppColors.black),
                                ),
                              )
                              : SizedBox.shrink(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, createPageRoute(ProfileSettingsScreen(initialIndex: widget.initialIndex)));
                      },
                      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                      borderRadius: BorderRadius.circular(AppSizes.cardRadiusMd),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(border: Border.all(color: AppColors.darkGrey), borderRadius: BorderRadius.circular(AppSizes.cardRadiusXl)),
                              child: CircleAvatar(
                                radius: 15,
                                backgroundImage: userImage != null ? NetworkImage(userImage) : null,
                                backgroundColor: AppColors.grey,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('By', style: TextStyle(fontWeight: FontWeight.w400, fontSize: AppSizes.fontSizeSm, color: AppColors.grey)),
                            const SizedBox(width: 4),
                            Text(
                              playlist['authorName'] ?? 'Unknown author',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeSm, color: AppColors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showImageDialog(BuildContext context, Map<String, dynamic> playlist) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(color: AppColors.black.withAlpha((0.8 * 255).toInt())),
              ),
            ),
            Positioned(
              top: 40,
              left: 20,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.darkGrey.withAlpha((0.5 * 255).toInt()),
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 22),
                ),
              ),
            ),
            Center(
              child: playlist['coverImage'] != null
                ? Container(
                  width: 330,
                  height: 330,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: AppColors.darkGrey, width: 1),
                  ),
                  child: ClipRect(
                    child: Image.network(
                      playlist['coverImage']!,
                      fit: BoxFit.cover,
                      width: 330,
                      height: 330,
                    ),
                  ),
                )
              : const CircleAvatar(radius: 100, backgroundColor: Colors.black54, child: Icon(Icons.person, size: 100, color: AppColors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSuggestionNewPlaylist(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Suggestions for your new playlist', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: AppColors.darkGrey, width: 1),
                        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image(
                          image: AssetImage(AppImages.playlist),
                          width: 65,
                          height: 65,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(playlistSuggestions[index], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text('Author #${index + 1}', style: TextStyle(fontSize: AppSizes.fontSizeSm, color: Colors.grey)),
                          Row(
                            children: [
                              const Icon(Icons.play_arrow, size: 16, color: AppColors.grey),
                              const SizedBox(width: 4),
                              Text('34', style: const TextStyle(color: AppColors.grey, fontSize: AppSizes.fontSizeSm)),
                              const SizedBox(width: 6),
                              const Text('·', style: TextStyle(color: AppColors.grey, fontSize: AppSizes.fontSizeSm)),
                              const SizedBox(width: 6),
                              Text('645'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(PixelArtIcons.add_box_multiple, size: 26),
                      onPressed: () {},
                    ),
                  ],
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 18),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _refreshSuggestions,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.isDarkMode ? AppColors.darkGrey : AppColors.lightGrey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  side: BorderSide.none,
                ),
                child: Text('Refresh suggestions', style: TextStyle(fontSize: AppSizes.fontSizeMd)),
              ),
            ),
          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
