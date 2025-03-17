import 'package:flutter/material.dart';
import '../../../../../../routes/custom_page_route.dart';
import '../../../../../../utils/constants/app_colors.dart';
import '../../../../../../utils/constants/app_sizes.dart';
import '../../../../../../utils/formatters/formatter.dart';
import '../../../profile_settings_screen.dart';

class PlaylistWidget extends StatelessWidget {
  final int initialIndex;
  final Map<String, dynamic> playlist;
  final Map<String, dynamic> userData;
  final VoidCallback? onImageTap;

  const PlaylistWidget({
    super.key,
    required this.initialIndex,
    required this.playlist,
    required this.userData,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    final userImage = userData['image'] as String?;

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 8, top: 12, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              playlist['coverImage'] != null
                ? GestureDetector(
                    onTap: onImageTap,
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.darkGrey, width: 0.8)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          playlist['coverImage'],
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : const Icon(Icons.music_note, size: 50, color: AppColors.grey),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(playlist['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeLg)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Text('Playlist · ${Formatter.formatReleaseDate(playlist['releaseDate'])}', style: TextStyle(fontSize: AppSizes.fontSizeSm)),
                            playlist['isPublic'] == false
                              ? Padding(
                                padding: const EdgeInsets.only(left: 6, top: 3),
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(color: AppColors.grey, shape: BoxShape.circle),
                                  child: Icon(Icons.lock, size: 13, color: AppColors.black),
                                ),
                              )
                              : SizedBox.shrink(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, createPageRoute(ProfileSettingsScreen(initialIndex: initialIndex)));
                      },
                      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                      borderRadius: BorderRadius.circular(AppSizes.cardRadiusMd),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(border: Border.all(color: AppColors.darkGrey), borderRadius: BorderRadius.circular(AppSizes.cardRadiusXl)),
                              child: CircleAvatar(
                                radius: 15,
                                backgroundImage: userImage != null ? NetworkImage(userImage) : null,
                                backgroundColor: AppColors.grey,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('By', style: TextStyle(fontWeight: FontWeight.w400, fontSize: AppSizes.fontSizeSm, color: AppColors.grey)),
                            const SizedBox(width: 4),
                            Text(
                              playlist['authorName'] ?? 'Unknown author',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeSm, color: AppColors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
