import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:jam_icons/jam_icons.dart';
import 'package:maestro/common/widgets/app_bar/app_bar.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import '../../../../api/apis.dart';
import '../../../../domain/entities/song/song_entity.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../home/screens/home_screen.dart';
import '../../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../../widgets/dialogs/sort_by_liked_tracks_bottom_dialog.dart';
import '../../widgets/input_fields/input_field.dart';
import '../../widgets/lists/track/liked_tracks_list.dart';

class LikedTracksScreen extends StatefulWidget {
  final List<SongEntity> likedTracks;
  final int initialIndex;

  const LikedTracksScreen({super.key, required this.likedTracks, required this.initialIndex});

  @override
  State<LikedTracksScreen> createState() => _LikedTracksScreenState();
}

class _LikedTracksScreenState extends State<LikedTracksScreen> {
  final GetStorage _storageBox = GetStorage();
  late final int selectedIndex;
  final TextEditingController _searchController = TextEditingController();
  List<SongEntity> filteredTracks = [];
  bool isShuffleActive = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    filteredTracks = widget.likedTracks;
    _searchController.addListener(_filterSongs);
    _loadLikedTracks();
    isShuffleActive = _storageBox.read('isShuffleActive') ?? false;
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterSongs);
    _searchController.dispose();
    super.dispose();
  }

  void _filterSongs() {
    setState(() {
      filteredTracks = widget.likedTracks.where((song) => song.title.toLowerCase().contains(_searchController.text.toLowerCase())).toList();
    });
  }

  Future<void> _reloadData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final id = user.uid;
        final tracks = await APIs.fetchLikedTracks(id);

        log("Reloaded ${tracks.length} liked tracks: ${tracks.map((t) => t.title).toList()}");

        await Future.delayed(const Duration(seconds: 1));

        setState(() {
          filteredTracks = tracks;
        });
      } else {
        log("User not authenticated");
      }
    } catch (e) {
      log("Error reloading liked tracks: $e");
    }
  }

  void _loadLikedTracks() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final id = user.uid;
        final tracks = await APIs.fetchLikedTracks(id);

        await Future.delayed(const Duration(milliseconds: 700));

        setState(() {
          filteredTracks = tracks;
          isLoading = false;
        });
      } else {
        log("User not authenticated");
      }
    } catch (e) {
      log("Error loading liked tracks: $e");
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
      appBar: BasicAppBar(
        title: const Text('Liked tracks', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
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
        child: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: RefreshIndicator(
            onRefresh: _reloadData,
            displacement: 0,
            color: AppColors.primary,
            backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.softGrey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 6, top: 16, bottom: 12),
                  child: InputField(
                    controller: _searchController,
                    hintText: 'Search ${filteredTracks.length} tracks',
                    icon: JamIcons.settingsAlt,
                    onIconPressed: () {
                      showSortByLikedTracksBottomDialog(context);
                    },
                  ),
                ),
                _buildActionIcons(),
                Expanded(
                  child: LikedTracksList(
                    tracks: filteredTracks,
                    userData: {},
                    shouldShowLikesListRow: false,
                  ),
                ),
              ],
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

  Widget _buildActionIcons() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_circle_down_outlined, size: 26),
            onPressed: () {},
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Bootstrap.shuffle, size: AppSizes.iconMd, color: isShuffleActive ? AppColors.primary : AppColors.grey),
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
}
