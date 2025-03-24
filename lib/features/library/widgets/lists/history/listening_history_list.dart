import 'package:flutter/material.dart';
import '../../../../../domain/entities/song/song_entity.dart';
import '../../../../../routes/custom_page_route.dart';
import '../../../screens/listening_history_screen.dart';
import '../../dialogs/info_track_bottom_dialog.dart';
import '../../items/track_item.dart';
import '../row/tracks_list_row.dart';

class ListeningHistoryList extends StatelessWidget {
  final List<SongEntity> tracks;
  final Map<String, dynamic> userData;
  final bool shouldShowLikesListRow;
  final bool isEditMode;

  const ListeningHistoryList({
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
              title: 'Listening history',
              onPressedSeeAll: () {
                Navigator.push(context, createPageRoute(ListeningHistoryScreen(initialIndex: 3, userData: userData, listeningHistory: tracks)));
              },
            ),
            ListView.builder(
              padding: EdgeInsets.zero,
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
                      shouldShowPlayNext: true,
                      shouldShowPlayLast: true,
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
