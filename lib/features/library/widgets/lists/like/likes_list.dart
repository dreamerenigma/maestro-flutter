import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/buttons/favorite_button.dart';
import '../../../../../domain/entities/song/song_entity.dart';
import '../../../../../routes/custom_page_route.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../song_player/bloc/song_player_cubit.dart';
import '../../../../song_player/bloc/song_player_state.dart';
import '../../../bloc/likes/likes_cubit.dart';
import '../../../bloc/likes/likes_state.dart';
import '../../../screens/library/playlists/playlist_screen.dart';

class LikesList extends StatelessWidget {
  final List<Map<String, dynamic>> playlists;
  final int initialIndex;

  const LikesList({super.key, required this.initialIndex, required this.playlists});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LikesCubit()..getLikes(),
      child: BlocBuilder<LikesCubit, LikesState>(
        builder: (context, state) {
          final cubit = context.read<LikesCubit>();

          if (state is LikesLoading && !cubit.hasDataLoaded) {
            return Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
            );
          }

          if (state is LikesLoaded) {
            final songs = state.songs.length > 5 ? state.songs.sublist(0, 5) : state.songs;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Likes', style: TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.w800, letterSpacing: -1.3)),
                      SizedBox(
                        width: 65,
                        height: 27,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              createPageRoute(PlaylistsScreen(playlists: playlists, initialIndex: initialIndex)),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.isDarkMode ? AppColors.darkGrey : AppColors.lightGrey,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                            side: BorderSide.none,
                          ).copyWith(
                            foregroundColor: WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.pressed)) {
                                return AppColors.darkerGrey;
                              } else {
                                return AppColors.white;
                              }
                            }),
                          ),
                          child: const Text('See All', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _songs(context, songs)
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _songs(BuildContext context, List<SongEntity> songs) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final song = songs[index];
        return GestureDetector(
          onTap: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.read<SongPlayerCubit>().playOrPauseSong(song);
                    },
                    child: BlocBuilder<SongPlayerCubit, SongPlayerState>(
                      builder: (context, state) {
                        final isPlaying = state is SongPlayerLoaded && state.currentSong == song && context.read<SongPlayerCubit>().audioPlayer.playing;
                        return Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: context.isDarkMode ? AppColors.darkGrey : AppColors.grey),
                          child: Icon(isPlaying ? Icons.pause : Icons.play_arrow_rounded, color: context.isDarkMode ? AppColors.darkerGrey : AppColors.grey),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(truncateWithEllipsis(14, song.title), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeMd)),
                      const SizedBox(height: 5),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(song.artist, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: AppSizes.fontSizeLm)),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Text(song.duration.toString().replaceAll('.', ':')),
                  const SizedBox(width: 20),
                  FavoriteButton(songEntity: song),
                ],
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemCount: songs.length,
    );
  }

  String truncateWithEllipsis(int cutoff, String text) {
    return (text.length <= cutoff) ? text : '${text.substring(0, cutoff)}...';
  }
}
