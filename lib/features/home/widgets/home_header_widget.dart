import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:evil_icons_flutter/evil_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:maestro/features/home/widgets/tabs/concerts_tab.dart';
import 'package:maestro/features/home/widgets/tabs/videos_tab.dart';
import 'package:maestro/features/home/widgets/your_likes_widget.dart';
import 'package:maestro/routes/custom_page_route.dart';
import '../../../api/apis.dart';
import '../../../data/services/history/history_firebase_service.dart';
import '../../../domain/entities/playlist/playable_item.dart';
import '../../../domain/entities/playlist/playlist_entity.dart';
import '../../../domain/entities/user/user_entity.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../service_locator.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../library/screens/library/playlists/playlist_screen.dart';
import '../../library/widgets/circular_animation.dart';
import '../../library/widgets/lists/history/recently_played_list.dart';
import '../../utils/screens/internet_aware_screen.dart';
import '../../utils/widgets/no_glow_scroll_behavior.dart';
import 'grids/latest_artists_follow_grid_widget.dart';
import 'grids/grid_widget.dart';
import 'grids/made_for_you_grid_widget.dart';
import 'tabs/news_songs_tab.dart';

class HomeScreenWidget extends StatefulWidget {
  final int unreadMessages;
  final bool isLoading;
  final VoidCallback onUpgradePressed;
  final VoidCallback onIconPressed;
  final Function() onInboxTapped;
  final Function() onNotificationsTapped;
  final int selectedIndex;
  final Function(int) onItemTapped;
  final Function(int) updateUnreadMessages;
  final VoidCallback reloadData;
  final TabController tabController;
  final int initialIndex;

  const HomeScreenWidget({
    super.key,
    required this.unreadMessages,
    required this.isLoading,
    required this.onUpgradePressed,
    required this.onIconPressed,
    required this.onInboxTapped,
    required this.onNotificationsTapped,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.updateUnreadMessages,
    required this.reloadData,
    required this.tabController,
    required this.initialIndex,
  });

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  late Future<Map<String, dynamic>?> userDataFuture;
  bool _isConnected = true;
  late int selectedPlaylistIndex;
  late List<PlayableItem> userEntities;
  List<PlayableItem> recentlyPlayed = [];

  @override
  void initState() {
    super.initState();
    userDataFuture = APIs.fetchUserData();
    _checkInternetConnection();
    _loadRecentlyPlayed();

    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      _isConnected = result != ConnectivityResult.none;
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routeArguments = ModalRoute.of(context)?.settings.arguments as Map?;
    selectedPlaylistIndex = routeArguments?['selectedPlaylistIndex'] ?? 0;
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

  void _checkInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: userDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)));
        } else if (snapshot.hasError || !snapshot.hasData) {
          return Center(child: Text(S.of(context).errorLoadingProfile));
        } else {
          final userData = snapshot.data;
          final userName = userData?['name'] ?? S.of(context).guest;

          return ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: RefreshIndicator(
              onRefresh: _reloadData,
              displacement: 100,
              color: AppColors.primary,
              backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.softGrey,
              child: Scaffold(
                body: Stack(
                  children: [
                    Column(
                      children: [
                        _buildAppBar(),
                        Flexible(
                          child: ListView(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            children: [
                              YourLikesWidget(padding: EdgeInsets.only(left: 16, right: 16, bottom: 6), initialIndex: widget.initialIndex),
                              _buildRecentlyPlayed(userData!),
                              LatestArtistsFollowGridWidget(padding: EdgeInsets.only(top: 20, bottom: 20)),
                              GridWidget(
                                padding: EdgeInsets.only(top: 8, bottom: 20),
                                sectionTitle: S.of(context).moreWhatYouLike,
                                itemCount: 10,
                                subtitleText: S.of(context).buzzingElectronic,
                                width: 130,
                                height: 130,
                                heights: 185,
                                onItemTap: () {
                                  Navigator.push(
                                    context,
                                    createPageRoute(PlaylistScreen(playlist: [], initialIndex: widget.initialIndex, selectedPlaylistIndex: selectedPlaylistIndex)),
                                  );
                                },
                              ),
                              _buildTabs(context),
                              SizedBox(
                                height: 260,
                                child: TabBarView(
                                  controller: widget.tabController,
                                  children: [
                                    const NewsSongsTab(),
                                    const VideosTab(),
                                    Container(),
                                    Container(),
                                    const ConcertsTab(),
                                  ],
                                ),
                              ),
                              GridWidget(
                                padding: EdgeInsets.only(top: 25, bottom: 10),
                                sectionTitle: S.of(context).mixedFor(userName),
                                subtitleText: S.of(context).buzzingElectronic,
                                itemCount: 10,
                                width: 130,
                                height: 130,
                                heights: 185,
                                onItemTap: () {},
                              ),
                              MadeForYouGridWidget(
                                padding: EdgeInsets.only(top: 25, bottom: 10),
                                sectionTitle: S.of(context).madeFor(userName),
                                itemCount: 2,
                                height: 250,
                                heights: 260,
                              ),
                              GridWidget(
                                padding: EdgeInsets.only(top: 25, bottom: 10),
                                sectionTitle: S.of(context).discoverStations,
                                subtitleText: S.of(context).buzzingElectronic,
                                itemCount: 5,
                                width: 130,
                                height: 130,
                                heights: 185,
                                onItemTap: () {},
                              ),
                              GridWidget(
                                padding: EdgeInsets.only(top: 25, bottom: 10),
                                sectionTitle: S.of(context).trendingGenre,
                                subtitleText: S.of(context).trendingMusic,
                                itemCount: 15,
                                width: 130,
                                height: 130,
                                heights: 185,
                                onItemTap: () {},
                              ),
                              GridWidget(
                                padding: EdgeInsets.only(top: 25, bottom: 10),
                                sectionTitle: S.of(context).curatedYourTaste,
                                subtitleText: S.of(context).buzzingElectronic,
                                itemCount: 10,
                                width: 130,
                                height: 130,
                                heights: 185,
                                onItemTap: () {},
                              ),
                              GridWidget(
                                padding: EdgeInsets.only(top: 25, bottom: 10),
                                sectionTitle: S.of(context).artistsWatchOutFor,
                                subtitleText: S.of(context).newArtists,
                                itemCount: 10,
                                width: 130,
                                height: 130,
                                heights: 185,
                                onItemTap: () {},
                              ),
                              Container(height: 50),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: kToolbarHeight + 30,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: InternetAwareScreen(title: S.of(context).home, connectedScreen: Container()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildTabs(BuildContext context) {
    return TabBar(
      controller: widget.tabController,
      dividerHeight: 0,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      indicator: BoxDecoration(
        color: context.isDarkMode ? AppColors.darkGrey : AppColors.lightGrey,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.darkerGrey.withAlpha((0.2 * 255).toInt()), width: 1),
      ),
      indicatorColor: AppColors.primary,
      labelColor: context.isDarkMode ? AppColors.white : AppColors.black,
      labelPadding: const EdgeInsets.only(left: 6, right: 6),
      unselectedLabelColor: context.isDarkMode ? AppColors.grey : AppColors.lightGrey,
      splashBorderRadius: BorderRadius.circular(4),
      padding: const EdgeInsets.all(10),
      splashFactory: NoSplash.splashFactory,
      overlayColor: WidgetStateProperty.all(AppColors.darkerGrey.withAlpha((0.2 * 255).toInt())),
      tabs: [
        SizedBox(
          width: 75,
          height: 35,
          child: Center(
            child: Text(S.of(context).news, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: AppSizes.fontSizeSm)),
          ),
        ),
        SizedBox(
          width: 75,
          height: 35,
          child: Center(
            child: Text(S.of(context).videos, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: AppSizes.fontSizeSm)),
          ),
        ),
        SizedBox(
          width: 75,
          height: 35,
          child: Center(
            child: Text(S.of(context).artists, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: AppSizes.fontSizeSm)),
          ),
        ),
        SizedBox(
          width: 90,
          height: 35,
          child: Center(
            child: Text(S.of(context).podcasts, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: AppSizes.fontSizeSm)),
          ),
        ),
        SizedBox(
          width: 90,
          height: 35,
          child: Center(
            child: Text(S.of(context).concerts, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: AppSizes.fontSizeSm)),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    double screenWidth = MediaQuery.of(context).size.width;
    double spacing20 = screenWidth > 390 ? 20 : 10;
    double spacing10 = screenWidth > 390 ? 10 : 5;
    double spacing8 = screenWidth > 390 ? 8 : 4;

    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8, top: 35, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(S.of(context).home, style: TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.bold)),
            ),
          ),
          Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: _isConnected ? GestureDetector(
                  onTap: widget.onUpgradePressed,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4, top: 3),
                    child: Text(S.of(context).upgrade, style: TextStyle(fontSize: AppSizes.fontSizeLm, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ),
                ) : Container(),
              ),
              SizedBox(width: spacing20),
              InkWell(
                onTap: () {},
                splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                borderRadius: BorderRadius.circular(50),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.cast, size: 22, color: context.isDarkMode ? AppColors.lightGrey : AppColors.black),
                ),
              ),
              SizedBox(width: spacing10),
              InkWell(
                onTap: widget.onIconPressed,
                splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                borderRadius: BorderRadius.circular(50),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.isLoading ? const CircularFillAnimation() : const Icon(Icons.arrow_circle_up_outlined, size: 24),
                ),
              ),
              SizedBox(width: spacing8),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  InkWell(
                    onTap: widget.onInboxTapped,
                    splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                    highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                    borderRadius: BorderRadius.circular(50),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(EvilIcons.envelope, size: 31, color: context.isDarkMode ? AppColors.lightGrey : AppColors.black),
                    ),
                  ),
                  if (widget.unreadMessages > 0)
                  Positioned(
                    right: 2,
                    top: 5,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(color: AppColors.red, shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Center(
                          child: Text('${widget.unreadMessages}', style: const TextStyle(color: AppColors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: spacing8),
              InkWell(
                onTap: widget.onNotificationsTapped,
                splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                borderRadius: BorderRadius.circular(50),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    AppVectors.notificationNone,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(context.isDarkMode ? AppColors.lightGrey : AppColors.black, BlendMode.srcIn),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentlyPlayed(Map<String, dynamic> userData) {
    List<PlayableItem> userEntities = recentlyPlayed;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
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
                  showRecentlyPlayedHomeItem: true,
                  shouldShowRecentlyPlayedListRow: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
