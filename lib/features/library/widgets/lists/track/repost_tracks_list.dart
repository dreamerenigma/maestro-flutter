import 'dart:developer';

import 'package:flutter/material.dart';
import '../../../../../domain/entities/reposts/repost_entity.dart';
import '../../../../../domain/entities/song/song_entity.dart';
import '../../../../../routes/custom_page_route.dart';
import '../../../screens/profile/all_tracks_screen.dart';
import '../../dialogs/info_track_bottom_dialog.dart';
import '../../items/track_item.dart';
import '../row/tracks_list_row.dart';

class RepostTrackList extends StatelessWidget {
  final List<RepostEntity> reposts;
  final Map<String, dynamic> userData;
  final bool shouldShowLikesListRow;
  final bool isEditMode;

  const RepostTrackList({
    super.key,
    required this.reposts,
    required this.userData,
    this.isEditMode = false,
    this.shouldShowLikesListRow = true,
  });

  @override
  Widget build(BuildContext context) {
    if (reposts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        children: [
          if (shouldShowLikesListRow)
            TracksListRow(
              shouldShow: true,
              songs: reposts.map((repost) => repost.getSong()).toList(), // Здесь используем getSong()
              initialIndex: 0,
              title: 'Reposts',
              onPressedSeeAll: () {
                Navigator.push(
                  context,
                  createPageRoute(AllTracksScreen(songs: reposts.map((repost) => repost.getSong()).toList(), initialIndex: 3)),
                );
              },
            ),
          FutureBuilder<List<SongEntity>>(
            future: _getRepostsSongs(), // Получаем список песен
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No reposts found.'));
              }

              final songs = snapshot.data!;

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final song = songs[index];

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
              );
            },
          ),
        ],
      ),
    );
  }

  Future<List<SongEntity>> _getRepostsSongs() async {
    final songs = <SongEntity>[];
    for (var repost in reposts) {
      try {
        final song = await repost.getSong();
        songs.add(song);
      } catch (e) {
        log('Error fetching song for repost ${repost.repostId}: $e');
      }
    }
    return songs;
  }
}
