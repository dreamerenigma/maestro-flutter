import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_colors.dart';

void showDeleteAccountDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        elevation: 4,
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.darkBackground : AppColors.lightBackground,
        titlePadding: const EdgeInsets.all(0),
        actionsPadding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
        contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 16),
        title: Stack(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 14, bottom: 12),
              child: Text('Delete account', style: TextStyle(fontSize: AppSizes.fontSizeBg)),
            ),
            Positioned(
              right: 0,
              top: 3,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
        content: const Text('This will delete all your audio recordings and all information. Are you sure you want to delete your account?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: context.isDarkMode ? AppColors.darkerGrey : AppColors.buttonSecondary,
              backgroundColor: context.isDarkMode ? AppColors.darkGrey : AppColors.buttonSecondary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text('Cancel', style: TextStyle(color: context.isDarkMode ? AppColors.white : AppColors.black, fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeMd)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await APIs.deleteAccount(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.red,
              backgroundColor: AppColors.red.withAlpha((0.2 * 255).toInt()),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text('Delete my account', style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeMd)),
          ),
        ],
      );
    },
  );
}
