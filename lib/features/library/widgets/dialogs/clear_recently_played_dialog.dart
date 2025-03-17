import 'package:flutter/material.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_colors.dart';

void showClearRecentlyPlayedDialog(BuildContext context) {
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
              child: Text('Clear recently played', style: TextStyle(fontSize: AppSizes.fontSizeBg)),
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
        content: const Text('Are you sure you want to clear your recently played? You won\'t be able to undo this action.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.buttonSecondary,
              backgroundColor: AppColors.buttonSecondary.withAlpha((0.2 * 255).toInt()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: const Text('Cancel', style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeMd)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await APIs.clearRecentlyPlayed(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.buttonSecondary,
              backgroundColor: AppColors.buttonSecondary.withAlpha((0.2 * 255).toInt()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: const Text('Clear', style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeMd)),
          ),
        ],
      );
    },
  );
}
