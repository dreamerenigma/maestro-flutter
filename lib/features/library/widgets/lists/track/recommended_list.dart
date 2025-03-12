import 'package:flutter/material.dart';
import 'package:maestro/domain/entities/song/song_entity.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../items/track_item.dart';

class RecommendedList extends StatelessWidget {
  final List<SongEntity> recommendedTracks;

  const RecommendedList({super.key, required this.recommendedTracks});

  @override
  Widget build(BuildContext context) {
    if (recommendedTracks.isEmpty) {
      return const Center(child: Text("No tracks", style: TextStyle(color: AppColors.grey)));
    }

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        children: [
          ListView.builder(
            itemCount: recommendedTracks.length,
            itemBuilder: (context, index) {
              final song = recommendedTracks[index];

              return TrackItem(song: song, onTap: () {});
            },
          ),
        ],
      ),
    );
  }
}
