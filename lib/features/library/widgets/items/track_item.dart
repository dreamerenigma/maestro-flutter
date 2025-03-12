import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../../domain/entities/song/song_entity.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../song_player/bloc/song_player_cubit.dart';
import '../../../song_player/bloc/song_player_state.dart';

class TrackItem extends StatelessWidget {
  final SongEntity song;
  final VoidCallback onTap;
  final VoidCallback? onMorePressed;
  final bool showMoreButton;
  final bool isFromTracksList;

  const TrackItem({
    super.key,
    required this.song,
    required this.onTap,
    this.onMorePressed,
    this.showMoreButton = true,
    this.isFromTracksList = false,
  });

  @override
  Widget build(BuildContext context) {

    String formatDuration(int durationInSeconds) {
      int minutes = durationInSeconds ~/ 60;
      int seconds = durationInSeconds % 60;
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }

    return BlocBuilder<SongPlayerCubit, SongPlayerState>(
      builder: (context, state) {
        final isPlaying = state is SongPlayerLoaded && state.currentSong == song && context.read<SongPlayerCubit>().audioPlayer.playing;
        return InkWell(
          onTap: () {
            if (!isPlaying) {
              context.read<SongPlayerCubit>().playOrPauseSong(song);
            } else {
              context.read<SongPlayerCubit>().playOrPauseSong();
            }
          },
          splashColor: context.isDarkMode ? AppColors.darkGrey.withAlpha((0.4 * 255).toInt()) : AppColors.grey.withAlpha((0.4 * 255).toInt()),
          highlightColor: context.isDarkMode ? AppColors.darkGrey.withAlpha((0.4 * 255).toInt()) : AppColors.grey.withAlpha((0.4 * 255).toInt()),
          child: Padding(
            padding: const EdgeInsets.only(left: 18, right: 8, top: 8, bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizes.cardRadiusXs),
                    border: Border.all(color: AppColors.darkGrey, width: 0.5),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        song.cover,
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
                        song.title.split('.').first,
                        style: const TextStyle(color: AppColors.white, fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        song.uploadedBy,
                        style: const TextStyle(color: AppColors.lightGrey, fontWeight: FontWeight.w200, fontSize: AppSizes.fontSizeMd, letterSpacing: -0.5),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.play_arrow, size: 16, color: AppColors.grey),
                          const SizedBox(width: 4),
                          Text(song.listenCount.toString(), style: const TextStyle(color: AppColors.grey, fontSize: AppSizes.fontSizeSm)),
                          const SizedBox(width: 6),
                          const Text('·', style: TextStyle(color: AppColors.grey, fontSize: AppSizes.fontSizeSm)),
                          const SizedBox(width: 6),
                          Text(formatDuration(song.duration.toInt()),
                            style: TextStyle(fontSize: AppSizes.fontSizeSm, fontFamily: 'Roboto', fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (showMoreButton)
                IconButton(
                  icon: const Icon(Icons.more_vert_rounded, size: AppSizes.iconLg, color: AppColors.grey),
                  onPressed: onMorePressed,
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
