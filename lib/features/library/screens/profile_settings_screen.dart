import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:maestro/api/apis.dart';
import 'package:maestro/features/home/widgets/lists/play_list.dart';
import 'package:maestro/features/library/screens/spotlight_screen.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import 'package:maestro/utils/constants/app_sizes.dart';
import 'package:typicons_flutter/typicons_flutter.dart';
import '../../../domain/entities/song/song_entity.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../data/sources/song/song_firebase_service.dart';
import '../../../generated/l10n/l10n.dart';
import '../../home/screens/home_screen.dart';
import '../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../controllers/background_controller.dart';
import '../controllers/profile_image_controller.dart';
import '../widgets/dialogs/share_profile_bottom_dialog.dart';
import '../widgets/dialogs/show_more_bio_info_bottom_dialog.dart';
import '../widgets/lists/tracks_list.dart';
import '../widgets/user_avatar_widget.dart';
import '../widgets/user_profile_info_widget.dart';
import 'edit_profile_screen.dart';
import 'library/your_insights_screen.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final int initialIndex;

  const ProfileSettingsScreen({super.key, required this.initialIndex});

  @override
  ProfileSettingsScreenState createState() => ProfileSettingsScreenState();
}

class ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final GetStorage _storageBox = GetStorage();
  final BackgroundController backgroundController = Get.put(BackgroundController());
  final ProfileImageController profileImageController = Get.put(ProfileImageController());
  late Future<Map<String, dynamic>?> userDataFuture;
  String? songId;
  final SongFirebaseServiceImpl songService = SongFirebaseServiceImpl();
  late final int selectedIndex;
  late final Function(int) onItemTapped;
  String? _imageUrlBg;
  String? _imageUrl;
  bool isShuffleActive = false;
  late ScrollController scrollController;
  double opacity = 1.0;
  double opacityUsername = 0;
  List<SongEntity> likedTracks = [];
  List<SongEntity> myTracks = [];
  List<Map<String, dynamic>> playlists = [];

  @override
  void initState() {
    super.initState();
    _loadImageUrls();
    userDataFuture = APIs.fetchUserData();
    songId = "someSongId";
    selectedIndex = widget.initialIndex;
    scrollController = ScrollController()..addListener(() {
      if (mounted) {
        setState(() {
          opacityUsername = (scrollController.offset / 100).clamp(0.0, 1.0);
        });
      }
    });

    backgroundController.backgroundImageUrl.listen((String? newBackground) {
      if (mounted) {
        setState(() {
          _imageUrlBg = newBackground;
        });
      }
    });

    profileImageController.profileImageUrl.listen((String? newProfileImage) {
      if (mounted) {
        setState(() {
          _imageUrl = newProfileImage;
        });
      }
    });

    _fetchLikedTracks();
    _fetchTracks();
    isShuffleActive = _storageBox.read('isShuffleActive') ?? false;
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _reloadData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  Future<void> _loadImageUrls() async {
    setState(() {
      _imageUrlBg = _storageBox.read<String>('backgroundImage');
      _imageUrl = _storageBox.read<String>('image');
    });
  }

  Future<void> _fetchLikedTracks() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final List<SongEntity> tracks = await APIs.fetchLikedTracks(user.uid);
        log('Tracks fetched from API: $tracks');
        if (mounted) {
          setState(() {
            likedTracks = tracks;
          });
        }
      } else {
        log('User is not authenticated');
      }
    } catch (e) {
      log('Error fetching liked tracks: $e');
    }
  }

  Future<void> _fetchTracks() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        log('User is not authenticated');
        return;
      }

      log('Fetching tracks for user: ${user.uid}');

      final tracks = await APIs.fetchTracks(user.uid);

      log('Fetched tracks: $tracks');

      if (mounted) {
        setState(() {
          myTracks = tracks;
          log('Tracks count: ${myTracks.length}');
        });
      }
    } catch (e) {
      log('Error fetching tracks: $e');
    }
  }

  void _toggleShuffle() {
    setState(() {
      isShuffleActive = !isShuffleActive;
    });
    _storageBox.write('isShuffleActive', isShuffleActive);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              final userData = snapshot.data!;

              return SafeArea(
                child: Stack(
                  children: [
                    ScrollConfiguration(
                      behavior: NoGlowScrollBehavior(),
                      child: RefreshIndicator(
                        onRefresh: _reloadData,
                        displacement: 0,
                        color: AppColors.primary,
                        backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.softGrey,
                        child: CustomScrollView(
                          controller: scrollController,
                          slivers: [
                            SliverAppBar(
                              pinned: true,
                              floating: false,
                              backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.backgroundColor : AppColors.white,
                              title: Opacity(
                                opacity: opacityUsername,
                                child: Text(
                                  userData['name'] as String? ?? 'No Name',
                                  style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? AppColors.white : AppColors.black, fontSize: 20),
                                ),
                              ),
                            ),
                            SliverList(
                              delegate: SliverChildListDelegate(
                                [
                                  _buildBackground(context, userData),
                                  const SizedBox(height: 50),
                                  _buildUserProfile(userData),
                                  _buildActionIcons(),
                                  const SizedBox(height: 15),
                                  _buildUserBioInfo(userData),
                                  _buildYourInsights('Your insights', Icons.arrow_forward_ios, () {
                                    Navigator.push(context, createPageRoute(YourInsightsScreen(initialIndex: widget.initialIndex)));
                                  }),
                                  const SizedBox(height: 20),
                                  _buildPinnedSpotlight(),
                                  TracksList(tracks: myTracks, userData: {}),
                                  PlayList(initialIndex: widget.initialIndex, playlists: playlists),
                                  // LikedTracksList(
                                  //   tracks: likedTracks ?? [],
                                  //   userData: userData ?? {},
                                  // ),
                                  SizedBox(height: 50),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildFixedIcons(context, userData),
                  ],
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

  Widget _buildBackground(BuildContext context, Map<String, dynamic> userData) {
    final imageUrl = userData['image'] as String?;

    return Container(
      height: 150,
      decoration: BoxDecoration(
        image: _imageUrlBg != null ? DecorationImage(image: NetworkImage(_imageUrlBg!), fit: BoxFit.cover) : null,
        color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkGrey : AppColors.lightBackground,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 70,
            left: 20,
            child: UserAvatar(imageUrl: imageUrl),
          ),
        ],
      ),
    );
  }

  Widget _buildFixedIcons(BuildContext context, Map<String, dynamic> userData) {
    return Positioned(
      left: 10,
      right: 6,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(color: AppColors.darkGrey, shape: BoxShape.circle),
              child: Icon(Icons.arrow_back_ios_new, size: 20, color: context.isDarkMode ? AppColors.white : AppColors.black),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(color: AppColors.darkGrey, shape: BoxShape.circle),
              child: const Icon(Icons.cast, size: 21, color: AppColors.white),
            ),
          ),
          IconButton(
            onPressed: () {
              showShareProfileDialog(context, userData);
            },
            icon: Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(color: AppColors.darkGrey, shape: BoxShape.circle),
              child: const Icon(Icons.more_vert, size: 21, color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile(Map<String, dynamic> userData) {
    final userName = userData['name'] as String?;
    final city = userData['city'] as String?;
    final country = userData['country'] as String?;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          UserProfileInfo(userName: userName, city: city, country: country, initialIndex: widget.initialIndex),
        ],
      ),
    );
  }

  Widget _buildActionIcons() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Typicons.pencil, size: AppSizes.iconLg),
            onPressed: () {
              Navigator.push(context, createPageRoute(EditProfileScreen(initialIndex: widget.initialIndex)));
            },
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Bootstrap.shuffle, color: isShuffleActive ? AppColors.primary : AppColors.grey, size: AppSizes.iconMd),
            onPressed: _toggleShuffle,
          ),
          const SizedBox(width: 5),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white,
            ),
            child: IconButton(
              icon: Icon(
                Icons.play_arrow_rounded,
                color: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
                size: 32,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserBioInfo(Map<String, dynamic> userData) {
    final userBioInfo = userData['bio'] as String?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Text('$userBioInfo', style: TextStyle(fontSize: 15, height: 1.2, letterSpacing: -0.3), maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
        SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: SizedBox(
            height: 30,
            child: TextButton(
              onPressed: () {
                showMoreBioInfoBottomDialog(context, userData);
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 10),
                foregroundColor: AppColors.blue.withAlpha((0.2 * 255).toInt())
              ),
              child: Text('Show more', style: const TextStyle(color: AppColors.blue, fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildYourInsights(String text, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: InkWell(
        onTap: onTap,
        splashColor: context.isDarkMode ? AppColors.darkGrey.withAlpha((0.2 * 255).toInt()) : AppColors.grey.withAlpha((0.4 * 255).toInt()),
        highlightColor: context.isDarkMode ? AppColors.darkGrey.withAlpha((0.2 * 255).toInt()) : AppColors.grey.withAlpha((0.4 * 255).toInt()),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            children: [
              Text(text, style: const TextStyle(fontSize: AppSizes.fontSizeMd)),
              const Spacer(),
              Icon(icon, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinnedSpotlight() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Pinned to Spotlight', style: TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.bold, letterSpacing: -1.3)),
              ),
              SizedBox(
                width: 50,
                height: 27,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, createPageRoute(SpotlightScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.isDarkMode ? AppColors.darkGrey : AppColors.lightGrey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                    side: BorderSide.none,
                  ).copyWith(
                    foregroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.pressed)) {
                        return AppColors.darkerGrey;
                      } else {
                        return AppColors.white;
                      }
                    }),
                  ),
                  child: const Text('Edit', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                ),
              ),
            ],
          ),
          Text(
            'Pin items to your Spotlight',
            style: TextStyle(color: AppColors.lightGrey, fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.normal, letterSpacing: -0.8),
          ),
        ],
      ),
    );
  }
}
