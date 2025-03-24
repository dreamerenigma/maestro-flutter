import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

String _generateUniqueId({int length = 64}) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random();

  return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
}

showQrCodeDialog(BuildContext context) {
  String shareId = _generateUniqueId();

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Align(
          alignment: Alignment.center,
          child: Material(
            borderRadius: BorderRadius.circular(20),
            color: context.isDarkMode ? AppColors.youngNight : AppColors.light,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              decoration: BoxDecoration(color: context.isDarkMode ? AppColors.youngNight : AppColors.light, borderRadius: BorderRadius.circular(25)),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: SizedBox(
                          width: 230,
                          height: 230,
                          child: QrImageView(
                            data: shareId,
                            version: QrVersions.auto,
                            size: 200.0,
                            gapless: true,
                            dataModuleStyle: QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: context.isDarkMode ? AppColors.white : AppColors.black),
                            eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.square, color: context.isDarkMode ? AppColors.white : AppColors.black),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Others can scan this QR code with a smartphone camera to visit the profile.',
                        style: TextStyle(fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.normal),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 8),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop(true);
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: AppColors.darkGrey,
                              foregroundColor: AppColors.darkerGrey.withAlpha((0.5 * 255).toInt()),
                              elevation: 0,
                              side: BorderSide.none,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              overlayColor: context.isDarkMode ? AppColors.black.withAlpha((0.5 * 255).toInt()) : AppColors.dark.withAlpha((0.5 * 255).toInt()),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text('Cancel', style: TextStyle(color: context.isDarkMode ? AppColors.white : AppColors.black, fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeMd)),
                          ),
                        ),
                      ),
                    ],
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
