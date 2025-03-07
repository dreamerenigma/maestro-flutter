import 'package:flutter/material.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

class NotificationSettingItem extends StatelessWidget {
  final String title;
  final bool isSwitchedOn;
  final ValueChanged<bool> onSwitchChanged;

  const NotificationSettingItem({
    super.key,
    required this.title,
    required this.isSwitchedOn,
    required this.onSwitchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: AppSizes.fontSizeLg,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Switch(
              value: isSwitchedOn,
              onChanged: onSwitchChanged,
              activeColor: AppColors.primary,
              inactiveTrackColor: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
