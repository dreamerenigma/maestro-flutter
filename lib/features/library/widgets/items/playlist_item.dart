import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';

class PlaylistItem extends StatelessWidget {
  final Map<String, dynamic> playlist;
  final VoidCallback onTap;
  final bool isCompactItem;

  const PlaylistItem({
    super.key,
    required this.playlist,
    required this.onTap,
    this.isCompactItem = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: isCompactItem ? _buildCompactLayout() : _buildDefaultLayout(),
      ),
    );
  }

  Widget _buildDefaultLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCoverImage(),
        const SizedBox(height: 4),
        Text(
          playlist['title'] ?? 'Untitled',
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, height: 1),
        ),
        Text(
          playlist['authorName'] ?? 'Unknown',
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 13, color: AppColors.grey),
        ),
      ],
    );
  }

  Widget _buildCompactLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildCoverImage(size: 65),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                playlist['title'] ?? 'Untitled',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, height: 1),
              ),
              Text(
                playlist['authorName'] ?? 'Unknown',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: AppColors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCoverImage({double size = 140}) {
    return playlist['coverImage'] != null
      ? Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.darkGrey, width: 0.8)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: playlist['coverImage'],
            width: size,
            height: size,
            fit: BoxFit.cover,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: AppColors.darkGrey,
              highlightColor: AppColors.steelGrey,
              child: Container(width: 45, height: 45, decoration: BoxDecoration(color: AppColors.white, shape: BoxShape.circle)),
            ),
            errorWidget: (context, url, error) => SvgPicture.asset(AppVectors.defaultAlbum, width: 22, height: 22),
          ),
        ),
      )
    : Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: AppColors.grey, borderRadius: BorderRadius.circular(8)),
        child: const Icon(Icons.music_note, size: 40, color: Colors.white),
      );
  }
}
