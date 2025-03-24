import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../library/widgets/tabs/tracks_tab.dart';
import '../tabs/albums_tab.dart';
import '../tabs/all_tab.dart';
import '../tabs/playlists_tab.dart';
import '../tabs/users_tab.dart';

class TabBarWidget extends StatefulWidget {
  final int initialIndex;

  const TabBarWidget({super.key, required this.initialIndex});

  @override
  TabBarWidgetState createState() => TabBarWidgetState();
}

class TabBarWidgetState extends State<TabBarWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this, initialIndex: widget.initialIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      initialIndex: _currentTabIndex,
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: AppColors.white,
            tabAlignment: TabAlignment.start,
            labelPadding: const EdgeInsets.only(left: 27, right: 27),
            labelColor: context.isDarkMode ? AppColors.white : AppColors.black,
            unselectedLabelColor: context.isDarkMode ? AppColors.grey : AppColors.lightGrey,
            splashBorderRadius: BorderRadius.circular(4),
            splashFactory: NoSplash.splashFactory,
            overlayColor: WidgetStateProperty.all(AppColors.darkerGrey.withAlpha((0.2 * 255).toInt())),
            dividerColor: AppColors.darkGrey,
            labelStyle: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.bold),
            onTap: (index) {
              setState(() {
                _currentTabIndex = index;
              });
              _tabController.index = index;
            },
            isScrollable: true,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Tracks'),
              Tab(text: 'Users'),
              Tab(text: 'Playlists'),
              Tab(text: 'Albums'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                AllTab(initialIndex: widget.initialIndex, searchQuery: ''),
                const TracksTab(),
                UsersTab(initialIndex: widget.initialIndex),
                const PlaylistsTab(),
                const AlbumsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
