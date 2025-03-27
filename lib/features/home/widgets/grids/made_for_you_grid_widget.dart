import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';

class MadeForYouGridWidget extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final String sectionTitle;
  final int itemCount;
  final double height;
  final double heights;

  const MadeForYouGridWidget({
    super.key,
    required this.padding,
    required this.sectionTitle,
    this.itemCount = 2,
    this.height = 130,
    this.heights = 150,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(sectionTitle, style: TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.w900)),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: heights,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildGridItem(
                    AppImages.albumSecondary,
                    AppImages.albumImage,
                    S.of(context).newReleases,
                    S.of(context).dailyDrops,
                    const EdgeInsets.only(right: 8.0),
                    AppColors.blue.withAlpha((0.4 * 255).toInt()),
                  ),
                  _buildGridItem(
                    AppImages.albumPrimary,
                    AppImages.playlist,
                    S.of(context).updatedEveryMonday,
                    S.of(context).weeklyWave,
                    const EdgeInsets.only(left: 8.0),
                    AppColors.primary.withAlpha((0.4 * 255).toInt()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(String imageAsset, String albumAsset, String description, String text, EdgeInsetsGeometry padding, Color colorLogo) {
    return Expanded(
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                splashColor: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
                highlightColor: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
                borderRadius: BorderRadius.circular(AppSizes.cardRadiusXl),
                child: Container(
                  width: height,
                  height: height,
                  decoration: BoxDecoration(color: Colors.blue[100], borderRadius: BorderRadius.circular(8)),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.asset(imageAsset, fit: BoxFit.cover)),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.black.withAlpha((0.4 * 255).toInt())),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: height,
                          height: height / 2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                AppColors.black.withAlpha((0.2 * 255).toInt()),
                                AppColors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(color: Colors.green[100], border: Border.all(color: AppColors.darkerGrey)),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 32, right: 32, top: 16, bottom: 45),
                                      child: ClipRRect(
                                        child: Container(
                                          width: 60,
                                          height: 60,
                                          padding: EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Colors.blue[100],
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [AppColors.buttonDarkGrey, AppColors.black],
                                            ),
                                          ),
                                          child: ClipRRect(
                                            child: Image.asset(albumAsset, fit: BoxFit.cover),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 6,
                                    left: 6,
                                    right: 6,
                                    child: Container(
                                      height: 30,
                                      padding: EdgeInsets.symmetric(horizontal: 4),
                                      decoration: BoxDecoration(color: AppColors.ascentBlue),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, textAlign: TextAlign.left),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 2,
                                    right: 2,
                                    child: ClipOval(
                                      child: Container(
                                        width: 23,
                                        height: 16,
                                        color: colorLogo,
                                        child: Padding(
                                          padding: const EdgeInsets.all(2),
                                          child: SvgPicture.asset(
                                            AppVectors.defaultAlbum,
                                            colorFilter: ColorFilter.mode(AppColors.black, BlendMode.srcIn),
                                            width: 13,
                                            height: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  description,
                                  style: const TextStyle(fontWeight: FontWeight.normal, height: 1.3, letterSpacing: -0.5),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
