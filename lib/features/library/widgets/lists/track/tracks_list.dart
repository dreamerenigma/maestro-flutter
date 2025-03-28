import 'package:flutter/material.dart';
import '../../../../../domain/entities/song/song_entity.dart';
import '../../../../../routes/custom_page_route.dart';
import '../../../screens/profile/all_tracks_screen.dart';
import '../../dialogs/info_track_bottom_dialog.dart';
import '../../items/track_item.dart';
import '../row/tracks_list_row.dart';

class TracksList extends StatelessWidget {
  final List<SongEntity> tracks;
  final Map<String, dynamic> userData;
  final bool shouldShowLikesListRow;
  final bool isEditMode;

  const TracksList({
    super.key,
    required this.tracks,
    required this.userData,
    this.isEditMode = false,
    this.shouldShowLikesListRow = true,
  });

  @override
  Widget build(BuildContext context) {
    final limitedTracks = tracks.take(3).toList();

    if (tracks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: SizedBox(
        child: Column(
          children: [
            if (shouldShowLikesListRow)
            TracksListRow(
              shouldShow: true,
              songs: tracks,
              initialIndex: 0,
              title: 'Tracks',
              onPressedSeeAll: () {
                Navigator.push(
                  context,
                  createPageRoute(AllTracksScreen(songs: tracks, initialIndex: 3)),
                );
              },
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: limitedTracks.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final song = limitedTracks[index];

                return TrackItem(
                  song: song,
                  isFromTracksList: true,
                  onTap: () {},
                  onMorePressed: () {
                    showInfoTrackBottomDialog(
                      context,
                      userData,
                      song,
                      isEditMode: isEditMode,
                      shouldShowRepost: false,
                      shouldShowPlayNext: false,
                      shouldShowPlayLast: false,
                      initialChildSize: 0.817,
                      maxChildSize: 0.817,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
