import 'package:flutter/material.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../widgets/nav_bar/bottom_nav_bar.dart';
import 'home_screen.dart';

class NotificationsScreen extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const NotificationsScreen({super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: Text(S.of(context).notifications),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list_sharp, size: 25),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cast, size: 25),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          _buildSection(S.of(context).nothingHappenedYet, S.of(context).nothingHappenedYetSubtitle),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: (index) {
          Navigator.pushReplacement(context, createPageRoute(HomeScreen(initialIndex: index)));
        },
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                content,
                style: const TextStyle(fontSize: AppSizes.fontSizeSm, color: AppColors.darkerGrey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
