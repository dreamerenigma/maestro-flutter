import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:maestro/common/widgets/app_bar/app_bar.dart';
import 'package:maestro/domain/entities/song/song_entity.dart';
import 'package:maestro/features/library/screens/library/station/widgets/cover_station_widget.dart';
import 'package:maestro/features/library/screens/library/station/widgets/station_action_icons_widget.dart';
import '../../../../../api/apis.dart';
import '../../../../../domain/entities/station/station_entity.dart';
import '../../../../../domain/entities/user/user_entity.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../routes/custom_page_route.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../home/screens/home_screen.dart';
import '../../../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../../widgets/dialogs/more_description_bottom_dialog.dart';
import '../../../widgets/lists/track/tracks_list.dart';
import '../../../widgets/user_info_widget.dart';

class StationScreen extends StatefulWidget {
  final List<SongEntity> song;
  final int initialIndex;
  final StationEntity station;
  final List<UserEntity> user;

  const StationScreen({
    super.key,
    required this.initialIndex,
    required this.station,
    required this.song,
    required this.user,
  });

  @override
  State<StationScreen> createState() => StationScreenState();
}

class StationScreenState extends State<StationScreen> {
  final GetStorage _storageBox = GetStorage();
  late final int selectedIndex;
  late Future<Map<String, dynamic>?> userDataFuture;
  bool isLoading = true;
  bool isShuffleActive = false;
  List<SongEntity> myTracks = [];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    userDataFuture = APIs.fetchUserData();
    _fetchTracks();
  }

  void _toggleShuffle() {
    setState(() {
      isShuffleActive = !isShuffleActive;
    });
    _storageBox.write('isShuffleActive', isShuffleActive);
  }

  Future<void> _fetchTracks() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        log('User is not authenticated');
        setState(() => isLoading = false);
        return;
      }

      final tracks = await APIs.fetchTracks(user.uid);

      if (mounted) {
        setState(() {
          myTracks = tracks;
          isLoading = false;
        });
      }
    } catch (e) {
      log('Error fetching tracks: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _reloadData() async {
    await Future.delayed(const Duration(seconds: 1));
    await _fetchTracks();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: const Text('Station', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
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
            ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)))
            : ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: RefreshIndicator(
            onRefresh: _reloadData,
            displacement: 0,
            color: AppColors.primary,
            backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.softGrey,
            child: FutureBuilder(
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

                  return ListView(
                    children: [
                      Column(
                        children: [
                          CoverStationWidget(station: widget.station),
                          StationActionIconsWidget(
                            station: widget.station,
                            isShuffleActive: isShuffleActive,
                            toggleShuffle: _toggleShuffle,
                            showLikeCount: true,
                            userData: {},
                            song: widget.song,
                          ),
                          UserInfoWidget(
                            userData: userData,
                            getInfoText: (userData) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18),
                                child: Text(
                                  'Based on ${widget.station.authorName} - ${widget.station.title}',
                                  style: TextStyle(fontSize: 15, height: 1.4, letterSpacing: -0.3), maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,
                                ),
                              );
                            },
                            onShowMorePressed: (context, userData) {
                              showMoreDescriptionBottomDialog(context, userData, 'Based on ${widget.station.authorName} - ${widget.station.title}');
                            },
                          ),
                          TracksList(tracks: myTracks, userData: {}, shouldShowLikesListRow: false),
                        ],
                      ),
                    ],
                  );
                }
              },
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
