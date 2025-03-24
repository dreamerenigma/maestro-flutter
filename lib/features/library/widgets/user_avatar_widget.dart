import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_vectors.dart';
import '../screens/profile/widgets/image_dialog.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;

  const UserAvatar({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: GestureDetector(
        onTap: () {
          if (imageUrl == null || imageUrl!.isEmpty || imageUrl == AppVectors.avatar) {
            return;
          } else {
            showImageDialog(context, imageUrl);
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Ink(
              decoration: BoxDecoration(
                color: AppColors.darkGrey,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.darkerGrey.withAlpha((0.2 * 255).toInt()), width: 1),
              ),
              child: CircleAvatar(
                maxRadius: 70,
                backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.lightGrey,
                backgroundImage: imageUrl != null && imageUrl!.isNotEmpty ? CachedNetworkImageProvider(imageUrl!) : null,
                child: imageUrl == null || imageUrl!.isEmpty ? SvgPicture.asset(AppVectors.avatar, width: 140, height: 140) : null,
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (imageUrl == null || imageUrl!.isEmpty || imageUrl == AppVectors.avatar) {
                    return;
                  } else {
                    showImageDialog(context, imageUrl);
                  }
                },
                splashColor: AppColors.steelGrey.withAlpha((0.2 * 255).toInt()),
                highlightColor: AppColors.steelGrey.withAlpha((0.2 * 255).toInt()),
                borderRadius: BorderRadius.circular(70),
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(70)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
