import 'package:flutter/material.dart';
import '../../../../../domain/entities/song/song_entity.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../dialogs/info_track_bottom_dialog.dart';
import '../../items/track_item.dart';
import '../row/tracks_list_row.dart';

class LikedTracksList extends StatelessWidget {
  final List<SongEntity> tracks;
  final Map<String, dynamic> userData;
  final bool shouldShowLikesListRow;

  const LikedTracksList({
    super.key,
    required this.tracks,
    required this.userData,
    this.shouldShowLikesListRow = true,
  });

  @override
  Widget build(BuildContext context) {
    if (tracks.isEmpty) {
      return const Center(child: Text("No liked tracks", style: TextStyle(color: AppColors.grey)));
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: SizedBox(
        child: Column(
          children: [
            if (shouldShowLikesListRow)
            TracksListRow(
              shouldShow: true,
              songs: tracks,
              initialIndex: 0,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tracks.length,
                itemBuilder: (context, index) {
                  final song = tracks[index];

                  return TrackItem(
                    song: song,
                    onTap: () {},
                    onMorePressed: () {
                      showInfoTrackBottomDialog(context, userData, song);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
