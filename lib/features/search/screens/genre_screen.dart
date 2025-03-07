import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../home/screens/home_screen.dart';
import '../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../widgets/app_bar/custom_sliver_app_bar.dart';

class GenreScreen extends StatefulWidget {
  final int initialIndex;
  final String genreName;
  final IconData genreIcon;

  const GenreScreen({super.key, required this.initialIndex, required this.genreName, required this.genreIcon});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> with SingleTickerProviderStateMixin {
  late final int selectedIndex;
  late TabController tabController;
  late ScrollController scrollController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    tabController = TabController(length: 4, vsync: this);
    scrollController = ScrollController();

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }

  Future<void> _reloadData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MiniPlayerManager(
        hideMiniPlayerOnSplash: false,
        child: ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: _isLoading ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary))) :
          NestedScrollView(
            controller: scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                CustomSliverAppBar(genreName: widget.genreName, tabController: tabController, scrollController: scrollController),
              ];
            },
            body: RefreshIndicator(
              onRefresh: _reloadData,
              displacement: 30,
              color: AppColors.primary,
              backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.softGrey,
              child: TabBarView(
                controller: tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Center(child: Text('Content for All')),
                  Center(child: Text('Content for Trending')),
                  Center(child: Text('Content for Playlist')),
                  Center(child: Text('Content for Albums')),
                ],
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
