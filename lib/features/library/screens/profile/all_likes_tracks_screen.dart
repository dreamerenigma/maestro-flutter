import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../common/widgets/app_bar/app_bar.dart';
import '../../../../domain/entities/song/song_entity.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../home/screens/home_screen.dart';
import '../../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../widgets/dialogs/info_track_bottom_dialog.dart';
import '../../widgets/items/track_item.dart';

class AllLikesTracksScreen extends StatefulWidget {
  final int initialIndex;
  final Map<String, dynamic> userData;

  const AllLikesTracksScreen({super.key, required this.initialIndex, required this.userData});

  @override
  State<AllLikesTracksScreen> createState() => _AllLikesTracksScreenState();
}

class _AllLikesTracksScreenState extends State<AllLikesTracksScreen> {
  late final int selectedIndex;
  late Future<Map<String, dynamic>?> userDataFuture;
  List<SongEntity> likedTracks = [];
  Set<String> selectedLikedTracks = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    userDataFuture = APIs.fetchUserData();
    _loadLikedTracks();
  }

  Future<void> _loadLikedTracks() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final List<SongEntity> tracks = await APIs.fetchLikedTracks(user.uid);
        if (mounted) {
          setState(() {
            likedTracks = tracks;
            isLoading = false;
          });
        }
      } else {
        log('User is not authenticated');
      }
    } catch (e) {
      log('Error fetching liked tracks: $e');
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
        title: const Text('Likes', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
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
        child: ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: RefreshIndicator(
            onRefresh: _reloadData,
            displacement: 0,
            color: AppColors.primary,
            backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.softGrey,
            child: isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : likedTracks.isEmpty
                ? const Center(child: Text('No tracks available', style: TextStyle(color: AppColors.grey)))
                : Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: ListView.builder(
                    itemCount: likedTracks.length,
                    itemBuilder: (context, index) {
                      final song = likedTracks[index];

                      return TrackItem(
                        song: song,
                        onTap: () {},
                        showMoreButton: true,
                        onMorePressed: () {
                          showInfoTrackBottomDialog(context, widget.userData, song, shouldShowRepost: false, initialChildSize: 0.943, maxChildSize: 0.943);
                        },
                      );
                    },
                  ),
              ),
          ),
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
}
