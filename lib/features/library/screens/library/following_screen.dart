import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestro/common/widgets/app_bar/app_bar.dart';
import 'package:maestro/features/library/screens/library/your_true_friends_screen.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../home/screens/home_screen.dart';
import '../../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';

class FollowingScreen extends StatefulWidget {
  final int initialIndex;

  const FollowingScreen({super.key, required this.initialIndex});

  @override
  State<FollowingScreen> createState() => FollowingScreenState();
}

class FollowingScreenState extends State<FollowingScreen> {
  late final int selectedIndex;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _reloadData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: const Text('Following', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
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
            child: ListView(
              children: [
                _buildFollowYouBack(),
                if (isLoading) _buildLoadingIndicator(),
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

  Widget _buildLoadingIndicator() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
      ),
    );
  }

  Widget _buildFollowYouBack() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Container(
        height: 70,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.youngNight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Material(
          color: AppColors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(context, createPageRoute(YourTrueFriendsScreen(initialIndex: widget.initialIndex)));
            },
            splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
            highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
            borderRadius: BorderRadius.circular(AppSizes.cardRadiusLg),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: AppColors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 1.5),
                    ),
                    child: Icon(CarbonIcons.group, color: AppColors.white, size: 22),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('People who follow you back', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.white)),
                      Text('See your true friends', style: TextStyle(fontSize: AppSizes.fontSizeSm, color: AppColors.lightGrey, fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(Icons.arrow_forward_ios, color: AppColors.white, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
