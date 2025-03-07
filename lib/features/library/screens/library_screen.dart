import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:maestro/features/library/screens/library/playlists_screen.dart';
import 'package:maestro/features/library/screens/library/your_insights_screen.dart';
import 'package:maestro/features/library/screens/recently_played_screen.dart';
import 'package:maestro/features/library/screens/settings_screen.dart';
import 'package:maestro/features/utils/screens/test_screen.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import 'package:maestro/routes/custom_page_route.dart';
import 'package:maestro/utils/constants/app_colors.dart';
import 'package:maestro/features/library/screens/library/liked_tracks_screen.dart';
import 'package:maestro/features/library/screens/local_audio_screen.dart';
import 'package:maestro/features/library/screens/profile_settings_screen.dart';
import 'package:maestro/features/library/screens/library/your_upload_screen.dart';
import 'package:shimmer/shimmer.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../home/bloc/play_list_cubit.dart';
import '../../home/bloc/play_list_state.dart';
import 'library/albums_screen.dart';
import 'library/following_screen.dart';
import 'library/stations_screen.dart';
import 'listening_history_screen.dart';

class LibraryScreen extends StatefulWidget {
  final int initialIndex;
  final VoidCallback onUpgradeTapped;
  final List<FileSystemEntity> audioFiles;

  const LibraryScreen({
    super.key,
    this.initialIndex = 3,
    required this.onUpgradeTapped,
    required this.audioFiles,
  });

  @override
  LibraryScreenState createState() => LibraryScreenState();
}

class LibraryScreenState extends State<LibraryScreen> {
  String? _userAvatarUrl;
  List<String> recentlyPlayed = [];
  final bool _isSeeAllTapped = false;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkInternetConnection();

    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      _isConnected = result != ConnectivityResult.none;

      setState(() {});
    });
  }

  void _checkInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  Future<void> _loadUserData() async {
    final userData = await fetchUserData();
    setState(() {
      _userAvatarUrl = userData?['image'];
    });
  }

  Future<Map<String, dynamic>?> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
      return userDoc.data() as Map<String, dynamic>?;
    }
    return null;
  }

  Future<void> _reloadData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlayListCubit()..getPlayList(),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _info(widget.onUpgradeTapped),
            Expanded(
              child: ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: RefreshIndicator(
                  onRefresh: _reloadData,
                  displacement: 0,
                  color: AppColors.primary,
                  backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.softGrey,
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            _buildProfileOption('Liked tracks', Icons.arrow_forward_ios, () {
                              Navigator.push(context, createPageRoute(LikedTracksScreen(likedTracks: [], initialIndex: widget.initialIndex)));
                            }),
                            BlocBuilder<PlayListCubit, PlayListState>(
                              builder: (context, state) {
                                if (state is PlayListLoaded) {
                                  return _buildProfileOption('Playlists', Icons.arrow_forward_ios, () {
                                    Navigator.push(
                                      context,
                                      createPageRoute(PlaylistsScreen(playlists: [], initialIndex: widget.initialIndex)),
                                    );
                                  });
                                } else {
                                  return _buildProfileOption('Playlists', Icons.arrow_forward_ios, () {});
                                }
                              },
                            ),
                            _buildProfileOption('Albums', Icons.arrow_forward_ios, () {
                              Navigator.push(context, createPageRoute(AlbumsScreen(initialIndex: widget.initialIndex, albums: [])));
                            }),
                            _buildProfileOption('Following', Icons.arrow_forward_ios, () {
                              Navigator.push(context, createPageRoute(FollowingScreen(initialIndex: widget.initialIndex)));
                            }),
                            _buildProfileOption('Stations', Icons.arrow_forward_ios, () {
                              Navigator.push(context, createPageRoute(StationsScreen(initialIndex: widget.initialIndex, stations: [])));
                            }),
                            _buildProfileOption('Local audio', Icons.arrow_forward_ios, () {
                              Navigator.push(context, createPageRoute(LocalAudioScreen(initialIndex: widget.initialIndex, songs: [])));
                            }),
                            _buildProfileOption('Your insights', Icons.arrow_forward_ios, () {
                              Navigator.push(context, createPageRoute(YourInsightsScreen(initialIndex: widget.initialIndex)));
                            }),
                            _buildProfileOption('Your uploads', Icons.arrow_forward_ios, () {
                              Navigator.push(context, createPageRoute(YourUploadScreen(initialIndex: widget.initialIndex)));
                            }),
                            _buildSection('Recently played', 'Find all your recently played content here.', () {
                              Navigator.push(context, createPageRoute(RecentlyPlayedScreen(initialIndex: widget.initialIndex)));
                            },
                              recentlyPlayed
                            ),
                            _buildSection('Listening history', 'Find all the tracks you\'ve listened to here.', () {
                              Navigator.push(context, createPageRoute(ListeningHistoryScreen(initialIndex: widget.initialIndex)));
                            },
                              recentlyPlayed
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(VoidCallback onUpgradeTapped) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 20),
      child: Row(
        children: [
          const Text('Library', style: TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.bold)),
          const Spacer(),
          _isConnected ? GestureDetector(
            onTap: onUpgradeTapped,
            child: const Text('UPGRADE', style: TextStyle(fontSize: AppSizes.fontSizeLm, fontWeight: FontWeight.bold, color: AppColors.primary)),
          ) : Container(),
          const SizedBox(width: 10),
          IconButton(
            icon: Icon(HugeIcons.strokeRoundedTestTube01, size: 24),
            onPressed: () {
              Navigator.push(context, createPageRoute(TestScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.cast, size: 24),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(CarbonIcons.settings, size: 26),
            onPressed: () {
              Navigator.push(context, createPageRoute(SettingsScreen(initialIndex: widget.initialIndex)));
            },
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              Navigator.push(context, createPageRoute(ProfileSettingsScreen(initialIndex: widget.initialIndex)));
            },
            child: _userAvatarUrl == null
              ? Shimmer.fromColors(
                baseColor: AppColors.grey.withAlpha((0.2 * 255).toInt()),
                highlightColor: AppColors.grey.withAlpha((0.6 * 255).toInt()),
                child: CircleAvatar(
                  maxRadius: 16,
                  backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.lightGrey,
                  child: const Icon(Icons.person, size: 16),
                ),
              )
            : CircleAvatar(
                maxRadius: 16,
                backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.lightGrey,
                backgroundImage: CachedNetworkImageProvider(_userAvatarUrl!),
                child: _userAvatarUrl == null ? const Icon(Icons.person, size: 16) : null,
              ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(String text, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      splashColor: context.isDarkMode ? AppColors.darkerGrey.withAlpha((0.2 * 255).toInt()) : AppColors.grey.withAlpha((0.4 * 255).toInt()),
      highlightColor: context.isDarkMode ? AppColors.darkerGrey.withAlpha((0.2 * 255).toInt()) : AppColors.grey.withAlpha((0.4 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Row(
          children: [
            Text(text, style: const TextStyle(fontSize: AppSizes.fontSizeMd)),
            const Spacer(),
            Icon(icon, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, VoidCallback onTap, List recentlyPlayed) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: AppSizes.fontSizeLg, fontWeight: FontWeight.bold)),
              if (recentlyPlayed.isNotEmpty)
              InkWell(
                onTap: onTap,
                splashColor: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
                highlightColor: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
                borderRadius: BorderRadius.circular(AppSizes.cardRadiusLg),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.darkGrey.withAlpha(30),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'See All',
                    style: TextStyle(
                      fontSize: AppSizes.fontSizeLm,
                      fontWeight: FontWeight.w500,
                      color: _isSeeAllTapped ? (HelperFunctions.isDarkMode(context) ? AppColors.white : AppColors.black) : (HelperFunctions.isDarkMode(context)
                        ? AppColors.white.withAlpha(150)
                        : AppColors.black.withAlpha(150))
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(content, style: const TextStyle(fontSize: AppSizes.fontSizeLm, color: AppColors.darkerGrey)),
          ),
        ],
      ),
    );
  }
}
