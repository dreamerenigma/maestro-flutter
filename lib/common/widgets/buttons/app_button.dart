import 'package:flutter/material.dart';
import 'package:maestro/utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';

class AppButton extends StatelessWidget {
  final VoidCallback callback;
  final String title;
  final double? height;

  const AppButton({super.key, required this.callback, required this.title, this.height});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color buttonColor = theme.brightness == Brightness.dark ? AppColors.white : AppColors.black;
    final Color textColor = theme.brightness == Brightness.dark ? AppColors.black : AppColors.white;

    return SizedBox(
      width: double.infinity,
      height: height ?? 72.0,
      child: ElevatedButton(
        onPressed: callback,
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColors.black,
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          side: BorderSide.none,
        ),
        child: Text(title, style: TextStyle(color: textColor, fontSize: AppSizes.fontSizeBg)),
      ),
    );
  }
}
