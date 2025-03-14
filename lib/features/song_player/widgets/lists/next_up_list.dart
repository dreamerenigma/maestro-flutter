import 'package:flutter/material.dart';
import '../../../../domain/entities/song/song_entity.dart';
import '../../../library/widgets/dialogs/info_track_bottom_dialog.dart';
import '../../../library/widgets/items/track_item.dart';

class NextUpList extends StatelessWidget {
  final List<SongEntity> tracks;
  final Map<String, dynamic> userData;
  final bool shouldShowLikesListRow;

  const NextUpList({
    super.key,
    required this.tracks, required this.userData, required this.shouldShowLikesListRow});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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
    );
  }
}
