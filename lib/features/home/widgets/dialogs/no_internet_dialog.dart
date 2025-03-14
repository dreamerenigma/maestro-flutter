import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_colors.dart';

void showNoInternetDialog(BuildContext context) {
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
                      Text(S.of(context).somethingWentWrong, style: TextStyle(fontSize: AppSizes.fontSizeLg, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Text(
                        S.of(context).pleaseSureInternetAvailable,
                        style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w200, color: context.isDarkMode ? AppColors.lightGrey : AppColors.black),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
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
                              child: Text(S.of(context).ok, style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeMd)),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: -15,
                    top: -12,
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
