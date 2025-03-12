import 'package:flutter/material.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';

class UserInfoWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final Widget Function(Map<String, dynamic>) getInfoText;
  final Function(BuildContext, Map<String, dynamic>) onShowMorePressed;

  const UserInfoWidget({super.key, required this.userData, required this.getInfoText, required this.onShowMorePressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getInfoText(userData),
          SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: SizedBox(
              height: 30,
              child: TextButton(
                onPressed: () {
                  onShowMorePressed(context, userData);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  foregroundColor: AppColors.blue.withAlpha((0.2 * 255).toInt()),
                ),
                child: Text('Show more', style: const TextStyle(color: AppColors.blue, fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
