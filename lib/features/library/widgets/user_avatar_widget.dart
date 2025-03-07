import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/app_colors.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;

  const UserAvatar({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImageDialog(context),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.darkGrey,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.darkGrey, width: 1),
        ),
        child: CircleAvatar(
          maxRadius: 70,
          backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.lightGrey,
          backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
          child: imageUrl == null ? const Icon(Icons.person, size: 30) : null,
        ),
      ),
    );
  }

  void _showImageDialog(BuildContext context) {
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
              top: 40,
              left: 20,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.darkGrey.withAlpha((0.5 * 255).toInt()),
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 22),
                ),
              ),
            ),
            Center(
              child: imageUrl != null
                ? Container(
                    width: 330,
                    height: 330,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.darkGrey, width: 1),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        width: 330,
                        height: 330,
                      ),
                    ),
                  )
                : const CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.black54,
                  child: Icon(Icons.person, size: 100, color: AppColors.white),
                ),
            ),
          ],
        );
      },
    );
  }
}
