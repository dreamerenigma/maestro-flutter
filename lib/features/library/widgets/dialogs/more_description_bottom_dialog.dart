import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

void showMoreDescriptionBottomDialog(BuildContext context, Map<String, dynamic> userData) {
  final userName = userData['name'] as String?;

  showModalBottomSheet(
    context: context,
    enableDrag: true,
    showDragHandle: false,
    isScrollControlled: true,
    backgroundColor: context.isDarkMode ? AppColors.backgroundColor : AppColors.lightBackground,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 5,
            width: 40,
            decoration: BoxDecoration(color: context.isDarkMode ? AppColors.white : AppColors.black, borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.only(top: 10, bottom: 6),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 36,
                  child: CircleAvatar(
                    backgroundColor: AppColors.darkGrey,
                    child: IconButton(
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: const Icon(Icons.close, color: AppColors.white, size: 23),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Text('Description', style: TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.bold, letterSpacing: -0.3)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Based on $userName', style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.normal)),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}

