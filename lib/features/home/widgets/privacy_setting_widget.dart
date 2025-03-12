import 'package:flutter/material.dart';
import 'package:maestro/utils/constants/app_colors.dart';
import 'package:maestro/utils/constants/app_sizes.dart';

import '../../library/widgets/switches.dart';

class PrivacySettingWidget extends StatelessWidget {
  final bool isPublic;
  final ValueChanged<bool> onToggle;

  const PrivacySettingWidget({
    super.key,
    required this.isPublic,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onToggle(!isPublic);
      },
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Make this track public', style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
            const SizedBox(width: 80),
            CustomSwitch(
              value: isPublic,
              onChanged: onToggle,
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
