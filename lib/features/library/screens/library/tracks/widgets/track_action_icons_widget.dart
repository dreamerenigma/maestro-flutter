import 'dart:developer';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../../common/widgets/buttons/favorite_button.dart';
import '../../../../../../domain/entities/song/song_entity.dart';
import '../../../../../../routes/custom_page_route.dart';
import '../../../../../../utils/constants/app_colors.dart';
import '../../../../../../utils/constants/app_sizes.dart';
import '../../../../../../utils/constants/app_vectors.dart';
import '../../../../../song_player/bloc/song_player_cubit.dart';
import '../../../../../song_player/screens/comments_screen.dart';
import '../../../../widgets/dialogs/info_track_bottom_dialog.dart';
import 'dialogs/repost_track_bottom_dialog.dart';

class TrackActionIconsWidget extends StatefulWidget {
  final int initialIndex;
  final SongEntity song;
  final int index;
  final Map<String, dynamic> userData;

  const TrackActionIconsWidget({
    super.key,
    required this.initialIndex,
    required this.song,
    required this.index,
    required this.userData,
  });

  @override
  TrackActionIconsWidgetState createState() => TrackActionIconsWidgetState();
}

class TrackActionIconsWidgetState extends State<TrackActionIconsWidget> {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      Get.snackbar('Error', 'You must be logged in to repost tracks');
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 20, bottom: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FavoriteButton(songEntity: widget.song, showLikeCount: true),
          SizedBox(width: 4),
          Row(
            children: [
              IconButton(
                icon: Transform.rotate(angle: 1.57, child: Icon(CarbonIcons.repeat, color: AppColors.darkerGrey, size: 23)),
                onPressed: () {
                  log('uploadedBy: ${widget.song.uploadedBy}, currentUser.uid: ${currentUser.uid}');

                  // if (widget.song.uploadedBy.trim() == widget.userData['name'].trim()) {
                  //   Get.snackbar('Info', 'You cannot repost your own track');
                  // } else {
                    showRepostTrackDialog(context, widget.userData, widget.initialIndex, widget.song);
                  // }
                },
              ),
              // Text('${widget.song.repostCount}', style: TextStyle(fontSize: AppSizes.fontSizeMd, color: context.isDarkMode ? AppColors.white : AppColors.black)),
            ],
          ),
          SizedBox(width: 6),
          Material(
            color: AppColors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  createPageRoute(CommentsScreen(song: widget.song, initialIndex: widget.initialIndex, comments: [])),
                );
              },
              splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
              highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
              borderRadius: BorderRadius.circular(AppSizes.cardRadiusXl),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppVectors.comment,
                      colorFilter: ColorFilter.mode(context.isDarkMode ? AppColors.white : AppColors.black, BlendMode.srcIn),
                      width: 22,
                      height: 22,
                    ),
                    const SizedBox(width: 8),
                    Text('${widget.song.commentsCount}', style: TextStyle(fontSize: AppSizes.fontSizeMd, color: context.isDarkMode ? AppColors.white : AppColors.black)),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 6),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, size: 23),
            onPressed: () {
              showInfoTrackBottomDialog(
                context,
                widget.userData,
                widget.song,
                shouldShowPlayNext: false,
                shouldShowPlayLast: false,
                shouldShowBehindThisTrack: false,
                shouldShowRepost: false,
                initialChildSize: 0.753,
                maxChildSize: 0.753,
              );
            },
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white,
            ),
            child: IconButton(
              icon: Icon(
                Icons.play_arrow_rounded,
                color: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
                size: 32,
              ),
              onPressed: () {
                context.read<SongPlayerCubit>().playOrPauseSong(widget.song);
              },
            ),
          ),
        ],
      ),
    );
  }
}
