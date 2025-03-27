import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:maestro/features/search/screens/follow_screen.dart';
import 'package:maestro/routes/custom_page_route.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../domain/entities/user/user_entity.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../buttons/follow_button.dart';

class UserItem extends StatelessWidget {
  final int initialIndex;
  final UserEntity user;
  final bool? hideFollowButton;

  const UserItem({
    super.key,
    required this.user,
    required this.initialIndex,
    this.hideFollowButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        Navigator.push(context, createPageRoute(FollowScreen(initialIndex: 2, user: user)));
      },
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 9, bottom: 9),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()), width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: user.image.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: user.image,
                      width: 65,
                      height: 65,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: AppColors.darkGrey,
                        highlightColor: AppColors.steelGrey,
                        child: Container(width: 45, height: 45, decoration: BoxDecoration(color: AppColors.white, shape: BoxShape.circle)),
                      ),
                      errorWidget: (context, url, error) => SvgPicture.asset(AppVectors.avatar, width: 22, height: 22),
                    )
                  : SvgPicture.asset(AppVectors.avatar, width: 65, height: 65),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  if (user.country.isNotEmpty)
                  Text(user.country, style: TextStyle(fontSize: 13, color: AppColors.grey, height: 1)),
                  SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: AppColors.buttonGrey),
                      SizedBox(width: 6),
                      Text('56.4K Followers', style: TextStyle(fontSize: 13, color: AppColors.darkerGrey)),
                    ],
                  ),
                ],
              ),
            ),
            if (!(hideFollowButton ?? true))
            FollowButton(initialIndex: initialIndex, isFollowing: false.obs, userEntity: user),
          ],
        ),
      ),
    );
  }
}
