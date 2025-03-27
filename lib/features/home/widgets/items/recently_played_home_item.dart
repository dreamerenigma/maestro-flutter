import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maestro/utils/constants/app_sizes.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_vectors.dart' show AppVectors;

class RecentlyPlayedHomeItem extends StatelessWidget {
  final bool isPlaylist;
  final bool isUserAvatar;
  final bool isStations;
  final String imageUrl;
  final String? userName;
  final String? authorName;
  final String? city;
  final String? country;
  final VoidCallback onTap;

  const RecentlyPlayedHomeItem({
    super.key,
    required this.isPlaylist,
    required this.isStations,
    required this.isUserAvatar,
    required this.imageUrl,
    required this.onTap,
    this.userName,
    this.authorName,
    this.city,
    this.country,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.darkGrey, borderRadius: BorderRadius.circular(AppSizes.cardRadiusSm)),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
          highlightColor: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
          borderRadius: BorderRadius.circular(AppSizes.cardRadiusSm),
          child: isUserAvatar
            ? Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()), width: 1),
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: 45,
                        height: 45,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: AppColors.darkGrey,
                          highlightColor: AppColors.steelGrey,
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
                          ),
                        ),
                        errorWidget: (context, url, error) => SvgPicture.asset(AppVectors.avatar, width: 22, height: 22),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: (city == null || city!.isEmpty) && (country == null || country!.isEmpty) ? Alignment.center : Alignment.centerLeft,
                          child: Text(
                            userName ?? '',
                            style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (city != null && city!.isNotEmpty && country != null && country!.isNotEmpty)
                          Text('$city, $country', style: TextStyle(fontSize: AppSizes.fontSizeLm, fontFamily: 'Roboto'), maxLines: 1, overflow: TextOverflow.ellipsis)
                        else if (city != null && city!.isNotEmpty)
                          Text('$city', style: TextStyle(fontSize: AppSizes.fontSizeLm, fontFamily: 'Roboto'), maxLines: 1, overflow: TextOverflow.ellipsis)
                        else if (country != null && country!.isNotEmpty)
                          Text('$country', style: TextStyle(fontSize: AppSizes.fontSizeLm, fontFamily: 'Roboto'), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
            )
            : isPlaylist
              ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()), width: 1),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: AppColors.darkGrey,
                            highlightColor: AppColors.steelGrey,
                            child: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(color: AppColors.white, shape: BoxShape.rectangle),
                            ),
                          ),
                          errorWidget: (context, url, error) => SvgPicture.asset(AppVectors.avatar, width: 22, height: 22),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(userName ?? '', style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text('$authorName', style: TextStyle(fontSize: AppSizes.fontSizeLm, fontFamily: 'Roboto'), overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
