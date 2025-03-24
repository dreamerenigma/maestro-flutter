import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:maestro/routes/custom_page_route.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../domain/entities/song/song_entity.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../home/screens/home_screen.dart';
import '../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../../utils/widgets/no_glow_scroll_behavior.dart';
import '../widgets/icons/action_icons_widget.dart';
import '../widgets/lists/history/listening_history_list.dart';

class ListeningHistoryScreen extends StatefulWidget {
  final int initialIndex;
  final Map<String, dynamic> userData;
  final List<SongEntity> listeningHistory;

  const ListeningHistoryScreen({
    super.key,
    required this.initialIndex,
    required this.userData,
    required this.listeningHistory,
  });

  @override
  State<ListeningHistoryScreen> createState() => ListeningHistoryScreenState();
}

class ListeningHistoryScreenState extends State<ListeningHistoryScreen> {
  late final int selectedIndex;
  List<SongEntity> listeningHistory = [];
  List<SongEntity> convertedTracks = [];
  bool isShuffleActive = false;
  final GetStorage _storageBox = GetStorage();
  RxBool isFollowing = false.obs;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    listeningHistory = widget.listeningHistory;
  }

  void _toggleShuffle() {
    setState(() {
      isShuffleActive = !isShuffleActive;
    });
    _storageBox.write('isShuffleActive', isShuffleActive);
  }

  Future<void> _reloadData() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      listeningHistory = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    List<SongEntity> convertedTracks = widget.listeningHistory;

    return Scaffold(
      appBar: BasicAppBar(
        title: const Text('Listening history', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cast, size: 22),
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
                  children: [
                    SizedBox(height: 20),
                    ActionIconsWidget(
                      isShuffleActive: isShuffleActive,
                      toggleShuffle: _toggleShuffle,
                      initialIndex: widget.initialIndex,
                      showDeleteHistory: true,
                      isFollowing: isFollowing,
                      showEditProfileButton: false,
                    ),
                    SizedBox(height: 10),
                    ListeningHistoryList(tracks: convertedTracks, userData: widget.userData, shouldShowLikesListRow: false),
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
}
