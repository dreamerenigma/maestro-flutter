import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/app_colors.dart';

void showImageDialog(BuildContext context, String? imageUrl, {BoxShape shape = BoxShape.circle}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: AppColors.black.withAlpha((0.8 * 255).toInt()),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 15,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.darkGrey.withAlpha((0.5 * 255).toInt())),
                child: const Icon(Icons.close, color: Colors.white, size: 22),
              ),
            ),
          ),
          Center(
            child: imageUrl != null
              ? Container(width: 330, height: 330, decoration: BoxDecoration(shape: shape, border: Border.all(color: AppColors.darkGrey, width: 1)),
                child: shape == BoxShape.circle
                  ? ClipOval(child: Image.network(imageUrl, fit: BoxFit.cover, width: 330, height: 330))
                  : ClipRRect(
                    borderRadius: BorderRadius.zero,
                    child: Image.network(imageUrl, fit: BoxFit.cover, width: 330, height: 330),
                  ),
                )
              : CircleAvatar(radius: 100, backgroundColor: AppColors.black.withAlpha((0.8 * 255).toInt()), child: Icon(Icons.person, size: 100, color: AppColors.white)),
          ),
        ],
      );
    },
  );
}
