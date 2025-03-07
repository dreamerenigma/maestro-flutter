import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';

class LatestArtistsFollowGridWidget extends StatelessWidget {
  final EdgeInsetsGeometry padding;

  const LatestArtistsFollowGridWidget({super.key, required this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Latest from artists you follow', style: TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) {
                bool isLastItem = index == 9;
                return Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: isLastItem ? 16 : 0,
                  ),
                  child: Stack(
                    children: [
                      Material(
                        color: AppColors.transparent,
                        child: InkWell(
                          onTap: () {},
                          splashColor: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
                          highlightColor: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
                          borderRadius: BorderRadius.circular(AppSizes.cardRadiusSm),
                          child: Stack(
                            children: [
                              Container(
                                width: 160,
                                height: 230,
                                decoration: BoxDecoration(
                                  color: AppColors.darkerGrey.withAlpha((0.5 * 255).toInt()),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.lightGrey.withAlpha((0.5 * 255).toInt()),
                                    width: 1,
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: AppColors.black.withAlpha((0.3 * 255).toInt()),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 10,
                        child: Text('TOP LEFT TEXT', style: TextStyle(fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.normal, color: AppColors.white, letterSpacing: -0.5)),
                      ),
                      Positioned(
                        left: 8,
                        bottom: 8,
                        child: Row(
                          children: [
                            Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.grey,
                                border: Border.all(color: AppColors.grey),
                              ),
                              child: ClipOval(
                                child: SvgPicture.asset(
                                  AppVectors.avatar,
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text('User Name', style: TextStyle(fontSize: AppSizes.fontSizeLm, fontWeight: FontWeight.normal, color: AppColors.white)),
                            SizedBox(width: 4),
                            Icon(FluentIcons.checkmark_starburst_16_filled, color: AppColors.blue, size: 18),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
