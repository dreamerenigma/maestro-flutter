import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../utils/constants/app_colors.dart';
import '../../../../../../../utils/constants/app_sizes.dart';

class AddCaptionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddCaptionButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          backgroundColor: context.isDarkMode ? AppColors.white : AppColors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          side: BorderSide.none,
          elevation: 4,
          shadowColor: AppColors.black.withAlpha((0.3 * 255).toInt()),
        ),
        child: Center(
          child: Text(
            'Add caption',
            style: TextStyle(color: context.isDarkMode ? AppColors.black : AppColors.white, fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
