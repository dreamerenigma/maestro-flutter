import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../common/widgets/app_bar/app_bar.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../home/screens/home_screen.dart';
import '../../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../library/playlists/playlist_screen.dart';

class AllPlaylistsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> playlists;
  final int initialIndex;

  const AllPlaylistsScreen({super.key, required this.initialIndex, required this.playlists});

  @override
  State<AllPlaylistsScreen> createState() => AllPlaylistsScreenState();
}

class AllPlaylistsScreenState extends State<AllPlaylistsScreen> {
  late final int selectedIndex;
  late Map<String, dynamic> userData;
  late Future<Map<String, dynamic>?> userDataFuture;
  List<Map<String, dynamic>> playlists = [];
  bool isLoading = true;
  late int selectedPlaylistIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    userDataFuture = APIs.fetchUserData();
    _loadPlaylists();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routeArguments = ModalRoute.of(context)?.settings.arguments as Map?;
    selectedPlaylistIndex = routeArguments?['selectedPlaylistIndex'] ?? 0;
  }

  Future<void> _loadPlaylists() async {
    try {
      if (userData['name'] == null) {
        log('User data is unavailable');
        return;
      }

      var snapshot = await FirebaseFirestore.instance
        .collection('Playlists')
        .where('authorName', isEqualTo: userData['name'])
        .get();

      log('Loaded ${snapshot.docs.length} playlists for current user');

      var playlistsData = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'title': doc['title'],
          'isPublic': doc['isPublic'],
          'releaseDate': doc['releaseDate'],
          'coverImage': doc['coverImage'],
          'authorName': doc['authorName'],
        };
      }).toList();

      setState(() {
        playlists = playlistsData;
        isLoading = false;
      });
    } catch (e) {
      log('Error loading playlists: $e');
    }
  }

  Future<void> _reloadData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: const Text('Playlists', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cast, size: 22, color: AppColors.grey),
          ),
        ],
      ),
      body: MiniPlayerManager(
        hideMiniPlayerOnSplash: false,
        child: FutureBuilder<Map<String, dynamic>?>(
          future: userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)));
            } else if (snapshot.hasError) {
              return Center(child: Text(S.of(context).errorLoadingProfile));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text(S.of(context).noUserDataFound));
            } else {
              userData = snapshot.data!;

              if (isLoading) {
                _loadPlaylists();
              }

              return isLoading
                ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)))
                : ScrollConfiguration(
                  behavior: NoGlowScrollBehavior(),
                  child: RefreshIndicator(
                    onRefresh: _reloadData,
                    displacement: 0,
                    color: AppColors.primary,
                    backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.softGrey,
                    child: Column(
                      children: [
                        _buildPlaylists(),
                      ],
                    ),
                  ),
                );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: (index) {
          Navigator.pushReplacement(context, createPageRoute(HomeScreen(initialIndex: index)));
        },
      ),
    );
  }

  Widget _buildPlaylists() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        final playlist = playlists[index];

        return InkWell(
          onTap: () {
            Navigator.push(context, createPageRoute(PlaylistScreen(initialIndex: widget.initialIndex, playlist: playlists, selectedPlaylistIndex: index)));
          },
          splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
          highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
          child: Padding(
            padding: const EdgeInsets.only(left: 18, right: 8, top: 12, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    playlist['coverImage'] != null
                      ? Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.darkGrey, width: 0.8)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            playlist['coverImage'],
                            width: 65,
                            height: 65,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : const Icon(Icons.music_note, size: 50, color: AppColors.grey),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(playlist['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeMd)),
                        Text(playlist['authorName'] ?? 'Unknown author', style: TextStyle(fontWeight: FontWeight.w400, fontSize: AppSizes.fontSizeSm, color: AppColors.grey)),
                        Row(
                          children: [
                            Text('Playlist' ' · ' '0 tracks', style: TextStyle(fontWeight: FontWeight.w400, fontSize: AppSizes.fontSizeSm, color: AppColors.grey)),
                            const SizedBox(width: 8),
                            playlist['isPublic'] == false ? Container(width: 15, height: 15, decoration: BoxDecoration(color: AppColors.grey, shape: BoxShape.circle),
                                child: Icon(Icons.lock, size: 13, color: AppColors.black),
                              )
                            : SizedBox.shrink(),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox.shrink(),
    );
  }
}
