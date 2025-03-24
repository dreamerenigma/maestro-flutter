import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/services/history/history_firebase_service.dart';
import '../../../../service_locator.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_colors.dart';

void showClearListeningHistoryDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Align(
          alignment: Alignment.center,
          child:  Material(
            borderRadius: BorderRadius.circular(20),
            color: context.isDarkMode ? AppColors.youngNight : AppColors.light,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: BoxDecoration(color: context.isDarkMode ? AppColors.youngNight : AppColors.light, borderRadius: BorderRadius.circular(25)),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Clear listening history?', style: TextStyle(fontSize: AppSizes.fontSizeBg)),
                      const SizedBox(height: 20),
                      const Text('Are you sure you want to clear your listening history? You wan\'t be able to undo thisaction.'),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.darkerGrey,
                              backgroundColor: context.isDarkMode ? AppColors.buttonDarkGrey : AppColors.darkGrey,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            child: Text('Cancel', style: TextStyle(color: context.isDarkMode ? AppColors.white : AppColors.black, fontWeight: FontWeight.bold, fontSize: 17)),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await sl<HistoryFirebaseService>().clearListeningHistory();

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Listening history cleared successfully!'))
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.red,
                              backgroundColor: AppColors.red.withAlpha((0.2 * 255).toInt()),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            child: Text('Clear', style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold, fontSize: 17)),
                          ),
                        ],
                      )
                    ],
                  ),
                  Positioned(
                    right: -15,
                    top: -9,
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
