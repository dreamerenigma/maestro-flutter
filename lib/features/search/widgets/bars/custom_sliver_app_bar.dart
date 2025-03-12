import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../../utils/constants/app_sizes.dart';

class CustomSliverAppBar extends StatelessWidget {
  final String genreName;
  final TabController tabController;
  final ScrollController scrollController;

  const CustomSliverAppBar({
    super.key,
    required this.genreName,
    required this.tabController,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 270,
      pinned: true,
      floating: false,
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.backgroundColor : AppColors.white,
      leading: IconButton(
        icon: Container(
          height: 34,
          width: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.isDarkMode ? AppColors.darkGrey : AppColors.lightGrey,
          ),
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: context.isDarkMode ? AppColors.white : AppColors.black,
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      flexibleSpace: SafeArea(
        child: FlexibleSpaceBar(
          titlePadding: EdgeInsets.zero,
          title: Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 40),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: AnimatedBuilder(
                animation: scrollController,
                builder: (context, child) {
                  double scrollOffset = scrollController.hasClients ? scrollController.offset : 0.0;
                  double moveX = 50 * (scrollOffset / 270);
                  double moveY = -25 * (scrollOffset / 270);
                  double fontSize = AppSizes.fontSizeLg - (scrollOffset / 270) * 10;
                  fontSize = fontSize < AppSizes.fontSizeLg ? AppSizes.fontSizeLg : fontSize;

                  return Transform.translate(
                    offset: Offset(moveX, moveY),
                    child: Text(
                      genreName,
                      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: AppColors.white),
                    ),
                  );
                },
              ),
            ),
          ),
          background: Image.asset(AppImages.genreBg, fit: BoxFit.cover),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: Material(
          color: Theme.of(context).brightness == Brightness.dark ? AppColors.backgroundColor : AppColors.white,
          child: TabBar(
            controller: tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: AppColors.white,
            labelColor: context.isDarkMode ? AppColors.white : AppColors.black,
            labelPadding: const EdgeInsets.only(left: 6, right: 6),
            unselectedLabelColor: context.isDarkMode ? AppColors.grey : AppColors.lightGrey,
            splashBorderRadius: BorderRadius.circular(4),
            splashFactory: NoSplash.splashFactory,
            overlayColor: WidgetStateProperty.all(AppColors.darkerGrey.withAlpha((0.2 * 255).toInt())),
            dividerColor: AppColors.darkGrey,
            labelStyle: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Trending'),
              Tab(text: 'Playlist'),
              Tab(text: 'Albums'),
            ],
          ),
        ),
      ),
    );
  }
}
