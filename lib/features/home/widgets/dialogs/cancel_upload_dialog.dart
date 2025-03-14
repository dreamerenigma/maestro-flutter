import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_colors.dart';

void showCancelUploadDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        elevation: 4,
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.youngNight : AppColors.lightBackground,
        titlePadding: const EdgeInsets.all(0),
        actionsPadding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
        contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 16),
        title: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 14, bottom: 12),
              child: Text(S.of(context).cancelUpload, style: TextStyle(fontSize: AppSizes.fontSizeBg)),
            ),
            Positioned(
              right: 0,
              top: 5,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
        content: Text(S.of(context).uploadingTrackStoppedDeleted),
        actions: [
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.darkerGrey,
                    backgroundColor: context.isDarkMode ? AppColors.buttonDarkGrey : AppColors.darkGrey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text(
                    S.of(context).resume,
                    style: TextStyle(color: context.isDarkMode ? AppColors.white : AppColors.black, fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeMd),
                  ),
                ),
                SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.red.withAlpha((0.5 * 255).toInt()),
                    backgroundColor: AppColors.red.withAlpha((0.2 * 255).toInt()),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text(S.of(context).cancelUpload, style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeMd)),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
