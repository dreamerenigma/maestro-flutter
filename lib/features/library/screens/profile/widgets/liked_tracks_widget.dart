import 'package:flutter/material.dart';
import '../../../../../domain/entities/song/song_entity.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../utils/widgets/no_glow_scroll_behavior.dart';

class LikedTracksWidget extends StatelessWidget {
  final List<SongEntity> likedTracks;
  final Set<String> selectedLikedTracks;
  final Map<String, dynamic> userData;
  final Function(String)? onTrackToggle;

  const LikedTracksWidget({
    super.key,
    required this.likedTracks,
    required this.selectedLikedTracks,
    required this.userData,
    this.onTrackToggle,
  });

  @override
  Widget build(BuildContext context) {
    List<SongEntity> filteredLikedTracks = likedTracks.where((likedTrack) {
      return likedTrack.uploadedBy == userData['name'];
    }).toList();

    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filteredLikedTracks.length,
        itemBuilder: (context, index) {
          final likedTrack = filteredLikedTracks[index];
          final bool isSelected = selectedLikedTracks.contains(likedTrack.songId);

          return InkWell(
            onTap: () {
              if (onTrackToggle != null) {
                onTrackToggle!(likedTrack.songId);
              }
            },
            splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
            highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? AppColors.darkGrey.withAlpha((0.4 * 255).toInt()) : AppColors.transparent,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 18, right: 8, top: 8, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        likedTrack.cover.isNotEmpty
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.darkGrey, width: 0.8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  likedTrack.cover,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : const Icon(Icons.music_note, size: 50, color: AppColors.grey),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              likedTrack.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              likedTrack.uploadedBy,
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: AppColors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        if (onTrackToggle != null) {
                          onTrackToggle!(likedTrack.songId);
                        }
                      },
                      icon: Icon(
                        isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
                        size: 24,
                        color: isSelected ? AppColors.grey : AppColors.darkerGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox.shrink(),
      ),
    );
  }
}
