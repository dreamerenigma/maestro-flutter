import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

Future<bool> showRefreshAppChangeFeedDialog(BuildContext context) async {
  bool? result = await showDialog<bool>(
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
                      Text('We need to refresh the app to change your Feed', style: TextStyle(fontSize: AppSizes.fontSizeLg, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Text('You will not be logged out.', style: TextStyle(fontSize: AppSizes.fontSizeSm)),
                      const SizedBox(height: 35),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: AppColors.buttonDarkGrey,
                                elevation: 0,
                                side: BorderSide.none,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                overlayColor: context.isDarkMode ? AppColors.black.withAlpha((0.5 * 255).toInt()) : AppColors.dark.withAlpha((0.5 * 255).toInt()),
                              ),
                              child: Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                Navigator.of(context).pop(true);
                                await APIs.clearRecentlyPlayed(context);
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: AppColors.red.withAlpha((0.1 * 255).toInt()),
                                elevation: 0,
                                side: BorderSide.none,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                overlayColor: context.isDarkMode ? AppColors.black.withAlpha((0.5 * 255).toInt()) : AppColors.dark.withAlpha((0.5 * 255).toInt()),
                              ),
                              child: Text('Restart', style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeMd)),
                            ),
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
  return result ?? false;
}

