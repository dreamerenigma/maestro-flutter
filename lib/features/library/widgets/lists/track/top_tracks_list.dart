import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../../domain/entities/song/song_entity.dart';
import '../../../../../routes/custom_page_route.dart';
import '../../../screens/profile/all_top_tracks_screen.dart';
import '../../dialogs/info_track_bottom_dialog.dart';
import '../../items/track_item.dart';
import '../row/tracks_list_row.dart';

class TopTracksList extends StatelessWidget {
  final List<SongEntity> tracks;
  final Map<String, dynamic> userData;
  final bool shouldShowLikesListRow;
  final bool isEditMode;

  const TopTracksList({
    super.key,
    required this.tracks,
    required this.userData,
    this.isEditMode = false,
    this.shouldShowLikesListRow = true,
  });

  @override
  Widget build(BuildContext context) {
    final limitedTracks = tracks.take(3).toList();

    if (tracks.isEmpty) return const SizedBox.shrink();

    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      throw Exception('No user logged in');
    }

    final isCurrentUser = userData['id'] == currentUser.uid;

    if (isCurrentUser) {
      final topTrack = tracks.reduce((a, b) {
        if (a.listenCount > b.listenCount) return a;
        if (a.listenCount == b.listenCount && a.likeCount > b.likeCount) return a;
        return b;
      });

      return Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Column(
          children: [
            if (shouldShowLikesListRow)
              TracksListRow(
                shouldShow: true,
                songs: [topTrack],
                initialIndex: 0,
                title: 'Top track',
                onPressedSeeAll: () {
                  Navigator.push(
                    context,
                    createPageRoute(AllTopTracksScreen(songs: [topTrack], initialIndex: 0)),
                  );
                },
              ),
            TrackItem(
              song: topTrack,
              isFromTracksList: true,
              onTap: () {},
              onMorePressed: () {
                showInfoTrackBottomDialog(
                  context,
                  userData,
                  topTrack,
                  isEditMode: isEditMode,
                  shouldShowRepost: false,
                  shouldShowPlayNext: false,
                  shouldShowPlayLast: false,
                  initialChildSize: 0.817,
                  maxChildSize: 0.817,
                );
              },
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        children: [
          if (shouldShowLikesListRow)
            TracksListRow(
              shouldShow: true,
              songs: limitedTracks,
              initialIndex: 0,
              title: 'Top tracks',
              onPressedSeeAll: () {
                Navigator.push(
                  context,
                  createPageRoute(AllTopTracksScreen(songs: limitedTracks, initialIndex: 3)),
                );
              },
            ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: limitedTracks.length,
            physics: const NeverScrollableScrollPhysics(),
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
    );
  }
}
