import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:maestro/features/library/screens/library/liked_tracks_screen.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';

class YourLikesWidget extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final int initialIndex;

  const YourLikesWidget({super.key, required this.padding, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: InkWell(
        onTap: () {
          Navigator.push(context, createPageRoute(LikedTracksScreen(likedTracks: [], initialIndex: initialIndex)));
        },
        splashColor: AppColors.darkerGrey.withAlpha((0.3 * 255).toInt()),
        highlightColor: AppColors.darkerGrey.withAlpha((0.3 * 255).toInt()),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.3, 1.0],
              colors: [
                AppColors.primary.withAlpha((0.6 * 255).toInt()),
                AppColors.primary.withAlpha((0.4 * 255).toInt()),
                AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 70,
                      height: 95,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 12,
                            left: -14,
                            child: SvgPicture.asset(
                              AppVectors.favorite,
                              width: 85,
                              height: 85,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('Your likes', style: TextStyle(fontSize: AppSizes.fontSizeLg, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {},
                  splashColor: AppColors.darkerGrey.withAlpha((0.7 * 255).toInt()),
                  highlightColor: AppColors.darkerGrey.withAlpha((0.7 * 255).toInt()),
                  borderRadius: BorderRadius.circular(AppSizes.cardRadiusXl),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.black.withAlpha((0.5 * 255).toInt())),
                    child: Icon(Ionicons.shuffle_outline, color: AppColors.white, size: AppSizes.iconLg),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
