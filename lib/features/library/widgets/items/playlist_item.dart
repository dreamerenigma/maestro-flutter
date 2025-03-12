import 'package:flutter/material.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

class PlaylistItem extends StatelessWidget {
  final Map<String, dynamic> playlist;
  final VoidCallback onTap;

  const PlaylistItem({super.key, required this.playlist, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      borderRadius: BorderRadius.circular(AppSizes.cardRadiusSm),
      child: Padding(
        padding: const EdgeInsets.only(left: 6, right: 8, top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            playlist['coverImage'] != null
              ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.darkGrey, width: 0.8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    playlist['coverImage'],
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                ),
              )
              : Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(color: AppColors.grey, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.music_note, size: 40, color: Colors.white),
              ),
            const SizedBox(height: 4),
            SizedBox(
              child: Text(
                playlist['title'] ?? 'Untitled',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, height: 1),
              ),
            ),
            SizedBox(
              child: Text(
                playlist['authorName'] ?? 'Unknown',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: AppColors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
