import 'package:flutter/material.dart';
import '../../../../../routes/custom_page_route.dart';
import '../../../screens/library/playlists/playlist_screen.dart';
import '../../items/playlist_item.dart';
import '../row/playlists_list_row.dart';

class PlaylistList extends StatelessWidget {
  final List<Map<String, dynamic>> playlists;
  final int initialIndex;
  final bool shouldShowLikesListRow;

  const PlaylistList({
    super.key,
    required this.playlists,
    required this.initialIndex,
    this.shouldShowLikesListRow = true,
  });

  @override
  Widget build(BuildContext context) {
    final limitedPlaylists = playlists.take(10).toList();

    if (playlists.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 6, bottom: 12),
      child: Column(
        children: [
          if (shouldShowLikesListRow)
          PlaylistListRow(
            shouldShow: true,
            playlists: playlists,
            initialIndex: 0,
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                final playlist = limitedPlaylists[index];

                return PlaylistItem(
                  playlist: playlist,
                  onTap: () {
                    Navigator.push(
                      context,
                      createPageRoute(PlaylistsScreen(initialIndex: initialIndex, playlists: playlists)),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
