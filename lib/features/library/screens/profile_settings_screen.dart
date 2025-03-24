import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:maestro/api/apis.dart';
import 'package:maestro/features/library/widgets/lists/playlist/playlist_list.dart';
import 'package:maestro/features/library/widgets/lists/track/repost_tracks_list.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import 'package:maestro/utils/constants/app_sizes.dart';
import '../../../data/services/song/song_firebase_service.dart';
import '../../../domain/entities/song/song_entity.dart';
import '../../../domain/entities/user/user_entity.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../generated/l10n/l10n.dart';
import '../../home/screens/home_screen.dart';
import '../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../../utils/screens/internet_aware_screen.dart';
import '../controllers/background_controller.dart';
import '../controllers/profile_image_controller.dart';
import '../widgets/dialogs/show_more_bio_info_bottom_dialog.dart';
import '../widgets/icons/action_icons_widget.dart';
import '../widgets/icons/fixed_icons_widget.dart';
import '../widgets/lists/track/liked_tracks_list.dart';
import '../widgets/lists/track/top_tracks_list.dart';
import '../widgets/lists/track/tracks_list.dart';
import '../widgets/pinned_spotlight_widget.dart';
import '../widgets/user_avatar_widget.dart';
import '../widgets/user_info_widget.dart';
import '../widgets/user_profile_info_widget.dart';
import 'library/your_insights_screen.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final int initialIndex;
  final UserEntity? user;

  const ProfileSettingsScreen({super.key, required this.initialIndex, this.user});

  @override
  ProfileSettingsScreenState createState() => ProfileSettingsScreenState();
}

class ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final GetStorage _storageBox = GetStorage();
  final BackgroundController backgroundController = Get.put(BackgroundController());
  final ProfileImageController profileImageController = Get.put(ProfileImageController());
  final ValueNotifier<double> opacityNotifier = ValueNotifier<double>(0);
  final SongFirebaseServiceImpl songService = SongFirebaseServiceImpl();
  late Future<Map<String, dynamic>?> userDataFuture;
  late final int selectedIndex;
  late final Function(int) onItemTapped;
  late ScrollController scrollController;
  String? songId;
  String? imageUrlBg;
  String? imageUrl;
  bool isShuffleActive = false;
  bool isConnected = true;
  RxBool isFollowing = false.obs;
  double opacity = 1.0;
  double opacityUsername = 0;
  double lastOffset = 0;
  List<SongEntity> likedTracks = [];
  List<SongEntity> myTracks = [];
  List<SongEntity> repostTracks = [];
  List<Map<String, dynamic>> playlists = [];

  @override
  void initState() {
    super.initState();
    _loadImageUrls();
    userDataFuture = APIs.fetchUserData();
    songId = "someSongId";
    selectedIndex = widget.initialIndex;
    scrollController = ScrollController();

    scrollController.addListener(() {
      double newOpacity = (scrollController.offset / 100).clamp(0.0, 1.0);
      opacityNotifier.value = newOpacity;
    });

    backgroundController.backgroundImageUrl.listen((String? newBackground) {
      if (mounted) {
        setState(() {
          imageUrlBg = newBackground;
        });
      }
    });

    profileImageController.profileImageUrl.listen((String? newProfileImage) {
      if (mounted) {
        setState(() {
          imageUrl = newProfileImage;
        });
      }
    });

    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      setState(() {
        isConnected = result != ConnectivityResult.none;
      });
    });

    _fetchLikedTracks();
    _fetchTracks();
    _fetchPlaylists();
    _checkInternetConnection();
    isShuffleActive = _storageBox.read('isShuffleActive') ?? false;
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _checkInternetConnection() async {
    bool hasConnection;
    try {
      final result = await InternetAddress.lookup('google.com');
      hasConnection = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      hasConnection = false;
    }
    setState(() {
      isConnected = hasConnection;
    });
  }

  Future<void> _loadImageUrls() async {
    setState(() {
      imageUrlBg = _storageBox.read<String>('backgroundImage');
      imageUrl = _storageBox.read<String>('image');
    });
  }

  Future<void> _fetchLikedTracks() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final List<SongEntity> tracks = await APIs.fetchLikedTracks(user.uid);
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

      final tracks = await APIs.fetchTracks(user.uid);

      if (mounted) {
        setState(() {
          myTracks = tracks;
        });
      }
    } catch (e) {
      log('Error fetching tracks: $e');
    }
  }

  void toggleShuffle() {
    setState(() {
      isShuffleActive = !isShuffleActive;
    });
    _storageBox.write('isShuffleActive', isShuffleActive);
  }

  Future<void> _reloadData() async {
    await Future.delayed(const Duration(seconds: 1));
    await _fetchLikedTracks();
    await _fetchTracks();
    await _fetchPlaylists();
    setState(() {});
  }

  Future<void> _fetchPlaylists() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('Playlists').get();
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
      });
    } catch (e) {
      log('Error loading playlists: $e');
    }
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
                            if (isConnected)
                            SliverAppBar(
                              pinned: true,
                              floating: false,
                              backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.backgroundColor : AppColors.white,
                              title: ValueListenableBuilder<double>(
                                valueListenable: opacityNotifier,
                                builder: (context, opacity, child) {
                                  return Opacity(opacity: opacity, child: child!);
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.darkGrey,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: AppColors.darkerGrey.withAlpha((0.2 * 255).toInt()), width: 1),
                                      ),
                                      child: CircleAvatar(
                                        radius: 18,
                                        backgroundImage: NetworkImage(userData['image'] ?? ''),
                                        backgroundColor: AppColors.lightGrey,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      userData['name'] as String? ?? 'No Name',
                                      style: TextStyle(
                                        color: Theme.of(context).brightness == Brightness.dark ? AppColors.white : AppColors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (isConnected)
                            SliverList(
                              delegate: SliverChildListDelegate(
                                [
                                  _buildBackground(context, userData),
                                  const SizedBox(height: 50),
                                  _buildUserProfile(userData),
                                  ActionIconsWidget(
                                    isShuffleActive: isShuffleActive,
                                    toggleShuffle: toggleShuffle,
                                    initialIndex: widget.initialIndex,
                                    isFollowing: isFollowing,
                                  ),
                                  const SizedBox(height: 15),
                                  UserInfoWidget(
                                    userData: userData,
                                    getInfoText: (userData) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: Text(
                                          userData['bio'] ?? 'Bio not specified',
                                          style: TextStyle(fontSize: 15, height: 1.2, letterSpacing: -0.3), maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,
                                        ),
                                      );
                                    },
                                    onShowMorePressed: (context, userData) {
                                      showMoreBioInfoBottomDialog(context, userData, widget.user);
                                    },
                                  ),
                                  _buildYourInsights('Your insights', Icons.arrow_forward_ios, () {
                                    Navigator.push(context, createPageRoute(YourInsightsScreen(initialIndex: widget.initialIndex)));
                                  }),
                                  const SizedBox(height: 20),
                                  const PinnedSpotlightWidget(),
                                  const SizedBox(height: 10),
                                  TopTracksList(tracks: myTracks, userData: userData),
                                  TracksList(tracks: myTracks, userData: userData),
                                  PlaylistList(
                                    initialIndex: widget.initialIndex,
                                    playlists: playlists.where((playlist) {
                                      return playlist['authorName'] == (userData['name'] ?? '');
                                    }).toList(),
                                  ),
                                  RepostTrackList(tracks: repostTracks, userData: userData),
                                  LikedTracksList(tracks: likedTracks, userData: userData),
                                  SizedBox(height: 100),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    FixedIconsWidget(
                      userData: userData,
                      user: widget.user,
                      isStartStation: true.obs,
                      isFollow: false.obs,
                      isMissingMusic: false.obs,
                      isReport: false.obs,
                      isBlockUser: false.obs,
                    ),
                    Positioned(
                      top: kToolbarHeight + 70,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Align(alignment: Alignment.topCenter, child: InternetAwareScreen(title: 'Profile Screen', connectedScreen: Container())),
                    ),
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
        image: imageUrlBg != null ? DecorationImage(image: CachedNetworkImageProvider(imageUrlBg!), fit: BoxFit.cover) : null,
        color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkGrey : AppColors.lightBackground,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(top: 70, left: 20, child: UserAvatar(imageUrl: imageUrl)),
        ],
      ),
    );
  }

  Widget _buildUserProfile(Map<String, dynamic> userData) {
    final userName = userData['name'] as String?;
    final city = userData['city'] as String?;
    final country = userData['country'] as String?;
    final displayCity = city ?? 'City not specified';
    final displayCountry = country ?? 'Country not specified';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          UserProfileInfo(
            userName: userName,
            city: displayCity,
            country: displayCountry,
            initialIndex: widget.initialIndex,
          ),
        ],
      ),
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
}
