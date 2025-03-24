import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../domain/entities/song/song_entity.dart';
import '../../../../../../domain/entities/station/station_entity.dart';
import '../../../../../../utils/constants/app_colors.dart';
import '../../../../../../utils/constants/app_sizes.dart';
import '../../../../../song_player/bloc/song_player_cubit.dart';
import '../../../../../song_player/bloc/song_player_state.dart';
import '../../../../widgets/dialogs/station_bottom_dialog.dart';
import 'package:get/get.dart';

class StationActionIconsWidget extends StatefulWidget {
  final StationEntity station;
  final bool isShuffleActive;
  final VoidCallback toggleShuffle;
  final Map<String, dynamic> userData;
  final bool showLikeCount;
  final List<SongEntity> song;

  const StationActionIconsWidget({
    super.key,
    required this.station,
    required this.isShuffleActive,
    required this.toggleShuffle,
    required this.userData,
    this.showLikeCount = true,
    required this.song,
  });

  @override
  StationActionIconsWidgetState createState() => StationActionIconsWidgetState();
}

class StationActionIconsWidgetState extends State<StationActionIconsWidget> {
  late int _likeCount;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.station.likesCount;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 20, bottom: 12),
      child: Row(
        children: [
          InkWell(
            onTap: () {},
            splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
            highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
            borderRadius: BorderRadius.circular(AppSizes.cardRadiusXl),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(
                    _likeCount > 0 ? Icons.favorite : Icons.favorite_border_rounded,
                    size: AppSizes.iconLg,
                    color: _likeCount > 0 ? AppColors.primary : context.isDarkMode ? AppColors.white : AppColors.black,
                  ),
                  if (widget.showLikeCount && _likeCount > 0) SizedBox(width: 5),
                  if (widget.showLikeCount && _likeCount > 0)
                  Text(
                    _likeCount.toString(),
                    style: TextStyle(
                      color: _likeCount > 0 ? AppColors.primary : context.isDarkMode ? AppColors.white : AppColors.black,
                      fontSize: AppSizes.fontSizeLg,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 20),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, size: AppSizes.iconLg),
            onPressed: () {
              showStationBottomDialog(context, widget.station);
            },
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              BootstrapIcons.shuffle,
              color: widget.isShuffleActive ? AppColors.primary : AppColors.white,
              size: AppSizes.iconMd,
            ),
            onPressed: widget.toggleShuffle,
          ),
          const SizedBox(width: 10),
          BlocBuilder<SongPlayerCubit, SongPlayerState>(
            builder: (context, state) {
              final isPlaying = context.read<SongPlayerCubit>().audioPlayer.playing;

              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).brightness == Brightness.light ? AppColors.lightGrey : AppColors.white,
                ),
                child: IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                    color: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
                    size: 32,
                  ),
                  onPressed: () {
                    context.read<SongPlayerCubit>().playOrPauseSong(widget.song.isNotEmpty ? widget.song[0] : null);
                  },
                ),
              );
            }
          ),
        ],
      ),
    );
  }
}
