import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:evil_icons_flutter/evil_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:maestro/features/home/widgets/profile_playlist_widget.dart';
import 'package:maestro/features/home/widgets/tabs/concerts_tab.dart';
import 'package:maestro/features/home/widgets/tabs/videos_tab.dart';
import 'package:maestro/features/home/widgets/your_likes_widget.dart';
import 'package:maestro/routes/custom_page_route.dart';
import '../../../api/apis.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../library/screens/library/playlist_screen.dart';
import '../../library/widgets/circular_animation.dart';
import '../../utils/screens/internet_aware_screen.dart';
import '../../utils/widgets/no_glow_scroll_behavior.dart';
import '../bloc/play_list_cubit.dart';
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

  @override
  void initState() {
    super.initState();
    userDataFuture = APIs.fetchUserData();
    _checkInternetConnection();

    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      _isConnected = result != ConnectivityResult.none;

      setState(() {});
    });
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
    return BlocProvider(
      create: (_) => PlayListCubit()..getPlayList(),
      child: FutureBuilder<Map<String, dynamic>?>(
        future: userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)));
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text(S.of(context).errorLoadingProfile));
          } else {
            final userData = snapshot.data;
            final userName = userData?['name'] ?? 'Guest';

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
                                YourLikesWidget(padding: EdgeInsets.only(left: 16, right: 16, bottom: 12), initialIndex: widget.initialIndex),
                                ProfilePlaylistWidget(padding: EdgeInsets.only(left: 16, right: 16, bottom: 35)),
                                LatestArtistsFollowGridWidget(padding: EdgeInsets.only(bottom: 30)),
                                GridWidget(
                                  padding: EdgeInsets.only(top: 8, bottom: 20),
                                  sectionTitle: 'More of what you like',
                                  itemCount: 10,
                                  subtitleText: 'Buzzing Electronic',
                                  width: 130,
                                  height: 130,
                                  heights: 185,
                                  onItemTap: () {
                                    Navigator.push(
                                      context,
                                      createPageRoute(PlaylistScreen(playlists: [], initialIndex: widget.initialIndex)),
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
                                  sectionTitle: 'Mixed for $userName',
                                  subtitleText: 'Buzzing Electronic',
                                  itemCount: 10,
                                  width: 130,
                                  height: 130,
                                  heights: 185,
                                  onItemTap: () {},
                                ),
                                MadeForYouGridWidget(
                                  padding: EdgeInsets.only(top: 25, bottom: 10),
                                  sectionTitle: 'Made for $userName',
                                  itemCount: 2,
                                  height: 250,
                                  heights: 260,
                                ),
                                GridWidget(
                                  padding: EdgeInsets.only(top: 25, bottom: 10),
                                  sectionTitle: 'Discover with Stations',
                                  subtitleText: 'Buzzing Electronic',
                                  itemCount: 5,
                                  width: 130,
                                  height: 130,
                                  heights: 185,
                                  onItemTap: () {},
                                ),
                                GridWidget(
                                  padding: EdgeInsets.only(top: 25, bottom: 10),
                                  sectionTitle: 'Trending by genre',
                                  subtitleText: 'Trending Music',
                                  itemCount: 15,
                                  width: 130,
                                  height: 130,
                                  heights: 185,
                                  onItemTap: () {},
                                ),
                                GridWidget(
                                  padding: EdgeInsets.only(top: 25, bottom: 10),
                                  sectionTitle: 'Curated to your taste',
                                  subtitleText: 'Buzzing Electronic',
                                  itemCount: 10,
                                  width: 130,
                                  height: 130,
                                  heights: 185,
                                  onItemTap: () {},
                                ),
                                GridWidget(
                                  padding: EdgeInsets.only(top: 25, bottom: 10),
                                  sectionTitle: 'Artists to watch out for',
                                  subtitleText: 'New!',
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
                          child: InternetAwareScreen(title: 'Главная', connectedScreen: Container()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
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
            child: Text(
              S.of(context).news,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: AppSizes.fontSizeSm),
            ),
          ),
        ),
        SizedBox(
          width: 75,
          height: 35,
          child: Center(
            child: Text(
              S.of(context).videos,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: AppSizes.fontSizeSm),
            ),
          ),
        ),
        SizedBox(
          width: 75,
          height: 35,
          child: Center(
            child: Text(
              S.of(context).artists,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: AppSizes.fontSizeSm),
            ),
          ),
        ),
        SizedBox(
          width: 90,
          height: 35,
          child: Center(
            child: Text(
              S.of(context).podcasts,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: AppSizes.fontSizeSm),
            ),
          ),
        ),
        SizedBox(
          width: 90,
          height: 35,
          child: Center(
            child: Text(
              'Концерты',
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: AppSizes.fontSizeSm),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 16, top: 35, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text('Главная', style: TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.bold)),
            ),
          ),
          Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: _isConnected ? GestureDetector(
                  onTap: widget.onUpgradePressed,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text('UPGRADE', style: TextStyle(fontSize: AppSizes.fontSizeLm, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ),
                ) : Container(),
              ),
              SizedBox(width: 20),
              InkWell(
                onTap: () {},
                splashColor: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
                highlightColor: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
                borderRadius: BorderRadius.circular(AppSizes.cardRadiusLg),
                child: Icon(Icons.cast, size: 22, color: context.isDarkMode ? AppColors.lightGrey : AppColors.black),
              ),
              SizedBox(width: 24),
              InkWell(
                onTap: widget.onIconPressed,
                splashColor: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
                highlightColor: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
                borderRadius: BorderRadius.circular(50),
                child: widget.isLoading ? const CircularFillAnimation() : const Icon(Icons.arrow_circle_up_outlined, size: 24),
              ),
              SizedBox(width: 18),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  InkWell(
                    onTap: widget.onInboxTapped,
                    splashColor: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
                    highlightColor: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
                    borderRadius: BorderRadius.circular(AppSizes.cardRadiusLg),
                    child: Icon(EvilIcons.envelope, size: 31, color: context.isDarkMode ? AppColors.lightGrey : AppColors.black),
                  ),
                  if (widget.unreadMessages > 0)
                    Positioned(
                      right: 0,
                      top: 0,
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
              SizedBox(width: 20),
              InkWell(
                onTap: widget.onNotificationsTapped,
                splashColor: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
                highlightColor: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
                borderRadius: BorderRadius.circular(AppSizes.cardRadiusLg),
                child: SvgPicture.asset(
                  AppVectors.notificationNone,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(context.isDarkMode ? AppColors.lightGrey : AppColors.black, BlendMode.srcIn),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
