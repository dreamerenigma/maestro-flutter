import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestro/routes/custom_page_route.dart';
import 'package:mono_icons/mono_icons.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../home/screens/home_screen.dart';
import '../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../../utils/widgets/no_glow_scroll_behavior.dart';
import '../widgets/dialogs/clear_recently_played.dart';

class RecentlyPlayedScreen extends StatefulWidget {
  final int initialIndex;

  const RecentlyPlayedScreen({super.key, required this.initialIndex});

  @override
  State<RecentlyPlayedScreen> createState() => RecentlyPlayedScreenState();
}

class RecentlyPlayedScreenState extends State<RecentlyPlayedScreen> {
  late final int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  Future<void> _reloadData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: const Text('Recently played', style: TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cast, size: 25),
          ),
          IconButton(
            onPressed: () {
              showClearRecentlyPlayedDialog(context);
            },
            icon: const Icon(MonoIcons.delete, size: 25),
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
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Find all your recently played content here.',
                      style: TextStyle(fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.w500),textAlign: TextAlign.left,
                    ),
                  ),
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
