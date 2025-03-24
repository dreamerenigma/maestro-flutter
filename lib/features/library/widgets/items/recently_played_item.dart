import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maestro/utils/constants/app_sizes.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/text/text_utils.dart';

class RecentlyPlayedItem extends StatelessWidget {
  final bool isPlaylist;
  final bool isUserAvatar;
  final bool isStations;
  final String imageUrl;
  final String? userName;
  final int? userFollowers;
  final VoidCallback onTap;

  const RecentlyPlayedItem({
    super.key,
    required this.isPlaylist,
    required this.isStations,
    required this.isUserAvatar,
    required this.imageUrl,
    required this.onTap,
    this.userName,
    this.userFollowers,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      borderRadius: BorderRadius.circular(AppSizes.cardRadiusSm),
      onTap: onTap,
      child: isUserAvatar
        ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80),
                  border: Border.all(color: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()), width: 1),
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 130,
                    height: 130,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: AppColors.darkGrey,
                      highlightColor: AppColors.steelGrey,
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
                      ),
                    ),
                    errorWidget: (context, url, error) => SvgPicture.asset(AppVectors.avatar, width: 65, height: 65),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(TextUtils.getTruncatedText(userName ?? '', 11), style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text('${userFollowers?.toString() ?? '0'} Followers', style: TextStyle(fontSize: AppSizes.fontSizeLm, fontFamily: 'Roboto')),
                ],
              ),
            ],
          ),
        )
      : Container(),
    );
  }
}
