import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../domain/entities/song/song_entity.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_urls.dart';

class TrackItem extends StatelessWidget {
  final SongEntity song;
  final VoidCallback onTap;
  final VoidCallback onMorePressed;

  const TrackItem({
    super.key,
    required this.song,
    required this.onTap,
    required this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: context.isDarkMode ? AppColors.darkGrey.withAlpha((0.4 * 255).toInt()) : AppColors.grey.withAlpha((0.4 * 255).toInt()),
      highlightColor: context.isDarkMode ? AppColors.darkGrey.withAlpha((0.4 * 255).toInt()) : AppColors.grey.withAlpha((0.4 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.only(left: 14, right: 8, top: 10, bottom: 10),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.cardRadiusXs),
                border: Border.all(color: AppColors.darkGrey, width: 0.5),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    '${AppURLs.coverFirestorage}${song.artist} - ${song.title}.jpg?${AppURLs.mediaAlt}',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${song.artist} - ${song.title}',
                    style: const TextStyle(color: AppColors.white, fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    song.artist,
                    style: const TextStyle(color: AppColors.lightGrey, fontSize: AppSizes.fontSizeMd, letterSpacing: -0.5),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.play_arrow, size: 16, color: AppColors.grey),
                      const SizedBox(width: 4),
                      Text(
                        song.listenCount.toString(),
                        style: const TextStyle(color: AppColors.grey, fontSize: AppSizes.fontSizeSm),
                      ),
                      const SizedBox(width: 6),
                      const Text('·', style: TextStyle(color: AppColors.grey, fontSize: AppSizes.fontSizeSm)),
                      const SizedBox(width: 6),
                      Text(song.duration.toString().replaceAll('.', ':')),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert_rounded, size: AppSizes.iconLg, color: AppColors.grey),
              onPressed: onMorePressed,
            ),
          ],
        ),
      ),
    );
  }
}
