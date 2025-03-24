import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestro/domain/entities/playlist/playlist_entity.dart';
import 'package:maestro/routes/custom_page_route.dart';
import 'package:mono_icons/mono_icons.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../data/services/history/history_firebase_service.dart';
import '../../../domain/entities/user/user_entity.dart';
import '../../../service_locator.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../home/screens/home_screen.dart';
import '../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../search/widgets/items/user_item.dart';
import '../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../../utils/widgets/no_glow_scroll_behavior.dart';
import '../widgets/dialogs/clear_recently_played_dialog.dart';
import '../widgets/items/playlist_item.dart';
import 'package:maestro/domain/entities/user/user_entity.dart' as user_entities;

class RecentlyPlayedScreen extends StatefulWidget {
  final int initialIndex;

  const RecentlyPlayedScreen({super.key, required this.initialIndex});

  @override
  State<RecentlyPlayedScreen> createState() => RecentlyPlayedScreenState();
}

class RecentlyPlayedScreenState extends State<RecentlyPlayedScreen> {
  late final int selectedIndex;
  List<dynamic> recentlyPlayed = [];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    _loadRecentlyPlayed();
  }

  void _loadRecentlyPlayed() async {
    try {
      List<Map<String, dynamic>> recently = await sl<HistoryFirebaseService>().fetchRecentlyPlayed();

      List<dynamic> items = recently.map((data) {
        if (data['type'] == 'user') {
          return UserEntity(
            id: data['id'] ?? '',
            name: data['name'] ?? 'Unknown',
            image: data['image'] ?? '',
            followers: data['followers'] ?? 0,
            bio: '',
            city: '',
            country: '',
            flag: '',
            backgroundImage: '',
            links: [],
            limitUploads: 0,
            tracksCount: 0,
            verifyAccount: false,
          );
        } else if (data['type'] == 'playlist') {
          return PlaylistEntity(
            title: data['title'] ?? 'Unknown Title',
            authorName: data['authorName'] ?? 'Unknown Author Name',
            description: data['description'] ?? '',
            releaseDate: data['releaseDate'] ?? Timestamp.now(),
            isFavorite: data['isFavorite'] ?? false,
            playlistId: data['playlistId'] ?? '',
            listenCount: data['listenCount'] ?? 0,
            coverImage: data['coverImage'] ?? '',
            likes: data['likes'] ?? 0,
            trackCount: data['trackCount'] ?? 0,
            tags: List<String>.from(data['tags'] ?? []),
            isPublic: data['isPublic'] ?? false,
          );
        }
        return null;
      }).where((item) => item != null).toList();

      setState(() {
        recentlyPlayed = items;
      });

      log('Recently played items loaded: $recentlyPlayed');
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
        child: Column(
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
                    _buildUserList(),
                  ],
                ),
              ),
            ),
          ],
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

  Widget _buildUserList() {
    if (recentlyPlayed.isEmpty) {
      return Center(child: Text('No recently played items.'));
    }

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 6),
      itemCount: recentlyPlayed.length,
      itemBuilder: (context, index) {
        final item = recentlyPlayed[index];

        if (item is user_entities.UserEntity) {
          return UserItem(user: item, initialIndex: widget.initialIndex, hideFollowButton: true);
        } else if (item is Map<String, dynamic>) {
          return PlaylistItem(playlist: item, onTap: () {});
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
