import 'package:flutter/material.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

class UploadsOptionWidget extends StatelessWidget {
  final String text;
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const UploadsOptionWidget({
    super.key,
    required this.text,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text, style: const TextStyle(fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.normal, letterSpacing: -0.7, color: AppColors.lightGrey)),
                  Text(title, style: const TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.normal, letterSpacing: -0.5), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Icon(icon, size: 22),
          ],
        ),
      ),
    );
  }
}
