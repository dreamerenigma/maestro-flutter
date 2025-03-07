import 'package:flutter/material.dart';
import 'package:gradient_widgets_plus/gradient_widgets_plus.dart';
import 'package:maestro/utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';

class BasicAppButton extends StatelessWidget {
  final VoidCallback callback;
  final String title;
  final double? height;

  const BasicAppButton({super.key, required this.callback, required this.title, this.height});

  @override
  Widget build(BuildContext context) {
    return GradientButton(
      gradient: const LinearGradient(
        colors: [AppColors.blue, AppColors.secondary, AppColors.primary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      increaseWidthBy: double.infinity,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      increaseHeightBy: height ?? 35.0,
      callback: callback,
      child: Text(title, style: const TextStyle(color: AppColors.white, fontSize: AppSizes.fontSizeBg)),
    );
  }
}
