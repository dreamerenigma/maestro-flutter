import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/app_bar/app_bar.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';

class EditPlaylist extends StatelessWidget {
  const EditPlaylist({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: BasicAppBar(
          title: Text('Edit', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
          saveButtonText: 'Save',
          onSavePressed: () {},
          showCloseIcon: true,
          centerTitle: false,
        ),
        body: Column(
          children: [
            TabBar(
              indicatorColor: context.isDarkMode ? AppColors.white : AppColors.black,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: context.isDarkMode ? AppColors.white : AppColors.black,
              labelPadding: const EdgeInsets.only(left: 6, right: 6),
              unselectedLabelColor: AppColors.grey,
              dividerColor: AppColors.transparent,
              tabs: [
                Tab(text: 'Tracks'),
                Tab(text: 'Details'),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  Center(child: Text('Details Content')),
                  Center(child: Text('Songs Content')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
