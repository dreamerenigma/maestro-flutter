import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestro/features/chats/widgets/tabs/likes_tab.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import '../../../api/apis.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../domain/entities/song/song_entity.dart';
import '../../../domain/entities/user/user_entity.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../chats/screens/user_message_screen.dart';
import '../../chats/widgets/tabs/playlist_tab.dart';
import '../../chats/widgets/tabs/uploads_tab.dart';
import '../widgets/bars/custom_tab_bar_indicator.dart';
import '../widgets/nav_bar/bottom_nav_bar.dart';
import 'home_screen.dart';

class AddTrackOrPlaylistScreen extends StatefulWidget {
  final int initialIndex;
  final Function(String) onFileURLSelected;
  final String initialFileURL;
  final UserEntity? user;

  const AddTrackOrPlaylistScreen({
    super.key,
    required this.initialIndex,
    required this.onFileURLSelected,
    required this.initialFileURL,
    this.user,
  });

  @override
  AddTrackOrPlaylistScreenState createState() => AddTrackOrPlaylistScreenState();
}

class AddTrackOrPlaylistScreenState extends State<AddTrackOrPlaylistScreen> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  late final int selectedIndex;
  Future<Map<String, dynamic>?>? userDataFuture;
  Set<String> selectedLikedTracks = {};
  late String fileURL;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    userDataFuture = APIs.fetchUserData();
    selectedIndex = widget.initialIndex;
    fileURL = widget.initialFileURL;
    log('Initial fileURL in AddTrackOrPlaylistScreen: $fileURL');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  void onTrackSelected(Set<String> selectedTracks) async {
    log("Tracks selected from LikesTab: $selectedTracks");

    setState(() {
      selectedLikedTracks = selectedTracks;
    });

    log("Updated selectedTracks in parent screen: $selectedLikedTracks");

    if (selectedLikedTracks.isNotEmpty) {
      String trackId = selectedLikedTracks.first;
      try {
        log("Fetching liked tracks for user: ${FirebaseAuth.instance.currentUser!.uid}");
        final tracks = await APIs.fetchLikedTracks(FirebaseAuth.instance.currentUser!.uid);
        log("Fetched tracks: $tracks");

        SongEntity track = tracks.firstWhere(
          (track) => track.songId == trackId,
          orElse: () {
            log("Track with songId $trackId not found.");
            throw Exception("Track with songId $trackId not found");
          },
        );

        log("Track found: ${track.songId}, navigating to UserMessageScreen");

        widget.onFileURLSelected(track.fileURL);
        Navigator.push(
          context,
          createPageRoute(
            UserMessageScreen(
              initialIndex: widget.initialIndex,
              user: widget.user,
              selectedFileURL: track.fileURL,
              selectedTrack: track,
            ),
          ),
        );
      } catch (e) {
        log('Error fetching liked tracks: $e');
      }
    } else {
      log('No track selected or liked tracks are empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: BasicAppBar(
        title: const Text('Add track or playlist', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
        centerTitle: false,
        showProgressDialog: false,
        onSavePressed: () {
          if (selectedLikedTracks.isNotEmpty) {
            String trackId = selectedLikedTracks.first;
            try {
              APIs.fetchLikedTracks(FirebaseAuth.instance.currentUser!.uid).then((tracks) {
                SongEntity track = tracks.firstWhere(
                  (track) => track.songId == trackId,
                  orElse: () {
                    log('Track not found');
                    throw Exception('Track not found');
                  },
                );
                String fileURL = track.fileURL;
                widget.onFileURLSelected(fileURL);
                log('Selected Track: $track');
              });
            } catch (e) {
              log('Error: $e');
            }
          } else {
            log('No track selected');
          }
        },
        saveButtonText: 'Done',
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cast, size: 22, color: AppColors.grey),
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: FutureBuilder<Map<String, dynamic>?>(
          future: userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)));
            }

            if (snapshot.hasError || snapshot.data == null) {
              return Center(child: Text('Ошибка загрузки пользователя'));
            }

            return _buildTabBar(snapshot.data!);
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

  Widget _buildTabBar(Map<String, dynamic> userData) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: CustomTabBarIndicator(color: AppColors.white),
          labelColor: context.isDarkMode ? AppColors.white : AppColors.black,
          labelPadding: const EdgeInsets.only(left: 6, right: 6),
          unselectedLabelColor: context.isDarkMode ? AppColors.grey : AppColors.lightGrey,
          splashBorderRadius: BorderRadius.circular(4),
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStateProperty.all(AppColors.darkerGrey.withAlpha((0.2 * 255).toInt())),
          dividerColor: AppColors.transparent,
          labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Likes'),
            Tab(text: 'Playlists'),
            Tab(text: 'Uploads'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              LikesTab(userData: userData, onTrackSelected: onTrackSelected),
              PlaylistTab(initialIndex: widget.initialIndex, userData: userData),
              UploadsTab(userData: userData),
            ],
          ),
        ),
      ],
    );
  }
}

