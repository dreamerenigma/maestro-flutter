import 'package:flutter/material.dart';
import 'package:maestro/features/library/screens/profile/all_likes_tracks_screen.dart';
import '../../../../../domain/entities/song/song_entity.dart';
import '../../../../../routes/custom_page_route.dart';
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
    final limitedLikesTracks = tracks.take(3).toList();

    if (tracks.isEmpty) {
      return const SizedBox.shrink();
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
              title: 'Likes',
              onPressedSeeAll: () {
                Navigator.push(
                  context,
                  createPageRoute(AllLikesTracksScreen(initialIndex: 3, userData: userData)),
                );
              },
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: limitedLikesTracks.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final song = limitedLikesTracks[index];

                return TrackItem(
                  song: song,
                  onTap: () {},
                  onMorePressed: () {
                    showInfoTrackBottomDialog(context, userData, song);
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
