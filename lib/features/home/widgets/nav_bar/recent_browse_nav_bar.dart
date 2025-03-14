import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:maestro/utils/constants/app_colors.dart';

import '../../../../generated/l10n/l10n.dart';

class RecentBrowseNavBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onItemTapped;
  final double height;

  const RecentBrowseNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.height = 70.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(18.0),
        topRight: Radius.circular(18.0),
      ),
      child: SizedBox(
        height: height,
        child: Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
          ),
          child: BottomNavigationBar(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.black
                : Colors.white,
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              _buildBottomNavigationBarItem(
                context,
                iconData: Icons.access_time_filled_sharp,
                label: S.of(context).recents,
                index: 0,
              ),
              _buildBottomNavigationBarItem(
                context,
                iconData: IonIcons.folder,
                label: S.of(context).browse,
                index: 1,
              ),
            ],
            currentIndex: selectedIndex,
            selectedItemColor: AppColors.white,
            unselectedItemColor: AppColors.darkerGrey,
            onTap: onItemTapped,
            selectedFontSize: 12,
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
    BuildContext context, {
      required IconData iconData,
      required String label,
      required int index,
      double iconSize = 30,
    }) {
    bool isSelected = selectedIndex == index;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    const Color selectedColor = AppColors.white;
    final Color unselectedColor = isDarkMode ? AppColors.darkerGrey : AppColors.black;

    Widget iconWidget = Icon(
      iconData,
      color: isSelected ? selectedColor : unselectedColor,
      size: iconSize,
    );

    return BottomNavigationBarItem(
      icon: Tooltip(
        richMessage: TextSpan(text: label, style: TextStyle(color: isDarkMode ? AppColors.white : AppColors.black)),
        decoration: BoxDecoration(color: isDarkMode ? AppColors.black : AppColors.grey, borderRadius: BorderRadius.circular(4)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
          child: iconWidget,
        ),
      ),
      label: label,
      tooltip: '',
    );
  }
}
