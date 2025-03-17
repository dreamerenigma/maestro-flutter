import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../dialogs/share_profile_bottom_dialog.dart';

class FixedIconsWidget extends StatelessWidget {
  final Map<String, dynamic> userData;

  const FixedIconsWidget({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 10,
      right: 6,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(color: AppColors.darkGrey, shape: BoxShape.circle),
              child: Icon(Icons.arrow_back_ios_new, size: 20, color: context.isDarkMode ? AppColors.white : AppColors.black),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(color: AppColors.darkGrey, shape: BoxShape.circle),
              child: const Icon(Icons.cast, size: 21, color: AppColors.white),
            ),
          ),
          IconButton(
            onPressed: () {
              showShareProfileDialog(context, userData);
            },
            icon: Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(color: AppColors.darkGrey, shape: BoxShape.circle),
              child: const Icon(Icons.more_vert, size: 21, color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
