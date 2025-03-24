import 'package:flutter/material.dart';
import '../../../../../domain/entities/song/song_entity.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../utils/widgets/no_glow_scroll_behavior.dart';

class TracksWidget extends StatelessWidget {
  final List<SongEntity> tracks;
  final Set<String> selectedTracks;
  final Map<String, dynamic> userData;
  final Function(String)? onTrackToggle;

  const TracksWidget({
    super.key,
    required this.tracks,
    required this.selectedTracks,
    required this.userData,
    this.onTrackToggle,
  });

  @override
  Widget build(BuildContext context) {
    List<SongEntity> filteredTracks = tracks.where((track) {
      return track.uploadedBy == userData['name'];
    }).toList();

    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filteredTracks.length,
        itemBuilder: (context, index) {
          final track = filteredTracks[index];
          final bool isSelected = selectedTracks.contains(track.songId);

          return InkWell(
            onTap: () {
              if (onTrackToggle != null) {
                onTrackToggle!(track.songId);
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
                        track.cover.isNotEmpty
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.darkGrey, width: 0.8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  track.cover,
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
                              track.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              track.uploadedBy,
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: AppColors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        if (onTrackToggle != null) {
                          onTrackToggle!(track.songId);
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
