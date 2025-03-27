import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:maestro/features/library/screens/library/playlists/view_playlists_screen.dart';
import 'package:maestro/features/library/screens/library/your_insights_screen.dart';
import 'package:maestro/features/library/screens/settings_screen.dart';
import 'package:maestro/features/utils/screens/test_screen.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import 'package:maestro/routes/custom_page_route.dart';
import 'package:maestro/utils/constants/app_colors.dart';
import 'package:maestro/features/library/screens/library/liked_tracks_screen.dart';
import 'package:maestro/features/library/screens/local_audio_screen.dart';
import 'package:maestro/features/library/screens/profile_settings_screen.dart';
import 'package:maestro/features/library/screens/library/your_upload_screen.dart';
import 'package:maestro/utils/constants/app_vectors.dart';
import 'package:shimmer/shimmer.dart';
import '../../../api/apis.dart';
import '../../../data/services/history/history_firebase_service.dart';
import '../../../domain/entities/playlist/playable_item.dart';
import '../../../domain/entities/playlist/playlist_entity.dart';
import '../../../domain/entities/song/song_entity.dart' as song;
import '../../../domain/entities/user/user_entity.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../service_locator.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../widgets/lists/history/listening_history_list.dart';
import '../widgets/lists/history/recently_played_list.dart';
import 'library/albums/albums_screen.dart';
import 'library/following_screen.dart';
import 'library/station/stations_screen.dart';

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
  List<song.SongEntity> listeningHistory = [];
  List<PlayableItem> recentlyPlayed = [];
  List<Map<String, dynamic>> playlists = [];
  late Map<String, dynamic> userData;
  late Future<Map<String, dynamic>?> userDataFuture;
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkInternetConnection();
    _loadListeningHistory();
    _loadRecentlyPlayed();
    userDataFuture = APIs.fetchUserData();
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      setState(() {
        isConnected = result != ConnectivityResult.none;
      });
    });
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

  void _loadListeningHistory() async {
    try {
      List<Map<String, dynamic>> history = await sl<HistoryFirebaseService>().fetchListeningHistory();
      List<song.SongEntity> tracks = history.map((trackData) {
      final duration = trackData['duration'] is String ? song.parseDuration(trackData['duration']) : trackData['duration'] ?? 0;

        return song.SongEntity(
          songId: trackData['songId'] ?? '',
          title: trackData['title'] ?? 'Unknown Track',
          artist: trackData['artist'] ?? 'Unknown Artist',
          cover: trackData['cover'] ?? '',
          releaseDate: trackData['timestamp'] ?? Timestamp.now(),
          genre: trackData['genre'] ?? '',
          description: trackData['description'] ?? '',
          caption: trackData['caption'] ?? '',
          duration: duration,
          isFavorite: trackData['isFavorite'] ?? false,
          listenCount: trackData['listenCount'] ?? 0,
          likeCount: trackData['likeCount'] ?? 0,
          commentsCount: trackData['commentsCount'] ?? 0,
          repostCount: trackData['repostCount'] ?? 0,
          fileURL: trackData['fileURL'] ?? '',
          uploadedBy: trackData['uploadedBy'] ?? '',
        );
      }).toList();

      setState(() {
        listeningHistory = tracks;
      });
    } catch (e) {
      log('Error loading listening history: $e');
    }
  }

  void _loadRecentlyPlayed() async {
    try {
      List<Map<String, dynamic>> recently = await sl<HistoryFirebaseService>().fetchRecentlyPlayed();

      List<PlayableItem> items = recently.map((data) {
        if (data['type'] == 'user') {
          return UserEntity(
            id: data['id'] ?? '',
            name: data['name'] ?? 'Unknown',
            image: data['image'] ?? '',
            followers: data['followers'] ?? 0,
            bio: '',
            city: data['city'] ?? '',
            country: data['country'] ?? '',
            flag: '',
            backgroundImage: '',
            links: [],
            limitUploads: 0,
            tracksCount: 0,
            verifyAccount: false,
          );
        } else if (data['type'] == 'playlist') {
          return PlaylistEntity(
            id: data['id'] ?? '',
            title: data['title'] ?? 'Untitled Playlist',
            authorName: data['authorName'] ?? 'Unknown Author',
            description: '',
            releaseDate: Timestamp.now(),
            isFavorite: false,
            listenCount: 0,
            coverImage: data['coverImage'] ?? '',
            likes: 0,
            trackCount: 0,
            tags: [],
            isPublic: false,
          );
        }
        throw Exception('Unknown type in recently played');
      }).toList();

      setState(() {
        recentlyPlayed = items;
      });
    } catch (e) {
      log('Error loading recently played: $e');
    }
  }

  Future<void> _reloadData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
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
            }

            userData = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfo(widget.onUpgradeTapped),
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
                                _buildProfileOption('Playlists', Icons.arrow_forward_ios, () {
                                  Navigator.push(context, createPageRoute(ViewPlaylistsScreen(playlists: playlists, initialIndex: widget.initialIndex)));
                                }),
                                _buildProfileOption('Albums', Icons.arrow_forward_ios, () {
                                  Navigator.push(context, createPageRoute(AlbumsScreen(initialIndex: widget.initialIndex, albums: [])));
                                }),
                                _buildProfileOption('Following', Icons.arrow_forward_ios, () {
                                  Navigator.push(context, createPageRoute(FollowingScreen(initialIndex: widget.initialIndex)));
                                }),
                                _buildProfileOption('Stations', Icons.arrow_forward_ios, () {
                                  Navigator.push(context, createPageRoute(StationsScreen(initialIndex: widget.initialIndex, stations: [], song: [])));
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
                                _buildRecentlyPlayed('Recently played', 'Find all your recently played content here.', userData),
                                _buildListeningHistory('Listening history', 'Find all the tracks you\'ve listened to here.', userData),
                                SizedBox(height: 50),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfo(VoidCallback onUpgradeTapped) {
    double screenWidth = MediaQuery.of(context).size.width;
    double spacing10 = screenWidth > 390 ? 10 : 5;
    double spacing8 = screenWidth > 390 ? 8 : 4;

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 20),
      child: Row(
        children: [
          const Text('Library', style: TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.bold)),
          const Spacer(),
          isConnected ? GestureDetector(
            onTap: onUpgradeTapped,
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 3),
              child: const Text('UPGRADE', style: TextStyle(fontSize: AppSizes.fontSizeLm, fontWeight: FontWeight.bold, color: AppColors.primary)),
            ),
          ) : Container(),
          SizedBox(width: spacing10),
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
          SizedBox(width: spacing8),
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
                  child: SvgPicture.asset(AppVectors.avatar, width: 16, height: 16),
                ),
              )
            : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.cardRadiusXl),
                border: Border.all(color: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()), width: 1),
              ),
              child: CircleAvatar(
                maxRadius: 16,
                backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.lightGrey,
                backgroundImage: CachedNetworkImageProvider(_userAvatarUrl!),
                child: _userAvatarUrl == null ? const Icon(Icons.person, size: 16) : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(String text, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      splashColor: context.isDarkMode ? AppColors.darkGrey.withAlpha((0.2 * 255).toInt()) : AppColors.grey.withAlpha((0.4 * 255).toInt()),
      highlightColor: context.isDarkMode ? AppColors.darkGrey.withAlpha((0.2 * 255).toInt()) : AppColors.grey.withAlpha((0.4 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Text(text, style: const TextStyle(fontSize: 17)),
            const Spacer(),
            Icon(icon, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentlyPlayed(String title, String content, Map<String, dynamic> userData) {
    List<PlayableItem> userEntities = recentlyPlayed;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(right: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (recentlyPlayed.isEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(title, style: const TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: RecentlyPlayedList(users: userEntities, userData: userData, initialIndex: widget.initialIndex),
              ),
            ],
          ),
          if (recentlyPlayed.isEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 6),
            child: Text(content, style: const TextStyle(fontSize: AppSizes.fontSizeLm, color: AppColors.darkerGrey)),
          ),
        ],
      ),
    );
  }

  Widget _buildListeningHistory(String title, String content, Map<String, dynamic> userData) {
    List<song.SongEntity> convertedTracks = listeningHistory;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(right: 6, top: 24, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (convertedTracks.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(title, style: const TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.bold)),
                ),
              Expanded(
                child: ListeningHistoryList(tracks: convertedTracks, userData: userData),
              ),
            ],
          ),
          if (convertedTracks.isEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 6),
              child: Text(content, style: const TextStyle(fontSize: AppSizes.fontSizeLm, color: AppColors.darkerGrey)),
            ),
        ],
      ),
    );
  }
}
