import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestro/domain/entities/playlist/playlist_entity.dart';
import 'package:maestro/routes/custom_page_route.dart';
import 'package:mono_icons/mono_icons.dart';
import '../../../api/apis.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../data/services/history/history_firebase_service.dart';
import '../../../domain/entities/playlist/playable_item.dart';
import '../../../domain/entities/user/user_entity.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../service_locator.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../home/screens/home_screen.dart';
import '../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../../utils/widgets/no_glow_scroll_behavior.dart';
import '../widgets/dialogs/clear_recently_played_dialog.dart';

import '../widgets/lists/history/recently_played_list.dart';

class RecentlyPlayedScreen extends StatefulWidget {
  final int initialIndex;
  final List<Map<String, dynamic>> playlists;
  final int selectedPlaylistIndex;

  const RecentlyPlayedScreen({
    super.key,
    required this.initialIndex,
    required this.selectedPlaylistIndex,
    required this.playlists,
  });

  @override
  State<RecentlyPlayedScreen> createState() => RecentlyPlayedScreenState();
}

class RecentlyPlayedScreenState extends State<RecentlyPlayedScreen> {
  late final int selectedIndex;
  late final int selectedPlaylistIndex;
  List<PlayableItem> recentlyPlayed = [];
  List<Map<String, dynamic>> playlists = [];
  late Map<String, dynamic> userData;
  late Future<Map<String, dynamic>?> userDataFuture;

  @override
  void initState() {
    super.initState();
    userDataFuture = APIs.fetchUserData();
    selectedIndex = widget.initialIndex;
    selectedPlaylistIndex = widget.selectedPlaylistIndex;
    _loadRecentlyPlayed();
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
            title: data['title'] ?? 'Unknown Title',
            authorName: data['authorName'] ?? 'Unknown Author Name',
            description: data['description'] ?? '',
            releaseDate: data['releaseDate'] ?? Timestamp.now(),
            isFavorite: data['isFavorite'] ?? false,
            listenCount: data['listenCount'] ?? 0,
            coverImage: data['coverImage'] ?? '',
            likes: data['likes'] ?? 0,
            trackCount: data['trackCount'] ?? 0,
            tags: List<String>.from(data['tags'] ?? []),
            isPublic: data['isPublic'] ?? false,
          );
        }
        return null;
      }).where((item) => item != null).cast<PlayableItem>().toList(); // Ensuring the type is PlayableItem

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
      appBar: BasicAppBar(
        title: const Text('Recently played', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cast, size: 22),
          ),
          IconButton(
            onPressed: () {
              showClearRecentlyPlayedDialog(context);
            },
            icon: const Icon(MonoIcons.delete, size: 23),
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

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ScrollConfiguration(
                    behavior: NoGlowScrollBehavior(),
                    child: RefreshIndicator(
                      onRefresh: _reloadData,
                      displacement: 0,
                      color: AppColors.primary,
                      backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.softGrey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                            child: Text(
                              '${recentlyPlayed.length} recently played items',
                              style: TextStyle(fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.w400, fontFamily: 'Roboto', color: AppColors.grey),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          _buildRecentlyPlayed(userData),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          }
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

  Widget _buildRecentlyPlayed(Map<String, dynamic> userData) {
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
              Expanded(
                child: RecentlyPlayedList(
                  users: userEntities,
                  userData: userData,
                  initialIndex: widget.initialIndex,
                  shouldShowRecentlyPlayedListRow: false,
                  showRecentlyPlayedItem: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
