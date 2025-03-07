import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mono_icons/mono_icons.dart';
import '../../../../utils/constants/app_colors.dart';

void showProfileImageBottomDialog(
    BuildContext context,
    Future<void> Function()? pickImageProfile,
    Future<void> Function()? takePhotoProfile,
    Future<void> Function()? clearBackgroundImage,
    Future<void> Function()? clearProfileImage,
    String deleteHeaderText,
  ) {
  showModalBottomSheet(
    context: context,
    enableDrag: true,
    showDragHandle: false,
    isScrollControlled: true,
    backgroundColor: context.isDarkMode ? AppColors.backgroundColor : AppColors.lightBackground,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 5,
              width: 40,
              decoration: BoxDecoration(
                color: context.isDarkMode ? AppColors.white : AppColors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(top: 10, bottom: 6),
            ),
            if (takePhotoProfile != null)
            _buildBottomSheetOption(
              icon: Icons.camera_alt_outlined,
              text: 'Take photo',
              onTap: () {
                takePhotoProfile();
                Navigator.pop(context);
              },
            ),
            if (pickImageProfile != null)
            _buildBottomSheetOption(
              icon: Ionicons.image_outline,
              text: 'Choose from Library',
              onTap: () {
                pickImageProfile();
                Navigator.pop(context);
              },
            ),
            if (clearBackgroundImage != null)
            _buildBottomSheetOption(
              icon: MonoIcons.delete,
              text: deleteHeaderText,
              onTap: () {
                clearBackgroundImage();
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 12)
          ],
        ),
      );
    },
  );
}

Widget _buildBottomSheetOption({
  required IconData icon,
  required String text,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
    highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
    child: Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 16),
          Text(text, style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal, letterSpacing: -0.3)),
        ],
      ),
    ),
  );
}
