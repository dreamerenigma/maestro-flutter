import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/app_colors.dart';
import '../screens/profile/widgets/image_dialog.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;

  const UserAvatar({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: () => showImageDialog(context, imageUrl),
        splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
        highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
        borderRadius: BorderRadius.circular(70),
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
      ),
    );
  }
}
