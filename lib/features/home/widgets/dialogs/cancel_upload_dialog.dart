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
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Align(
          alignment: Alignment.center,
          child: Material(
            borderRadius: BorderRadius.circular(20),
            color: context.isDarkMode ? AppColors.youngNight : AppColors.light,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: BoxDecoration(color: context.isDarkMode ? AppColors.youngNight : AppColors.light, borderRadius: BorderRadius.circular(25)),
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 20, bottom: 12),
                        child: Text(S.of(context).cancelUpload, style: TextStyle(fontSize: AppSizes.fontSizeBg)),
                      ),
                      Text(S.of(context).uploadingTrackStoppedDeleted),
                      const SizedBox(height: 35),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
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
                            child: Text(S.of(context).cancel, style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeMd)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    right: -15,
                    top: -10,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
