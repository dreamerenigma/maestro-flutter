import 'package:flutter/material.dart';
import '../../../../../../domain/entities/station/station_entity.dart';
import '../../../../../domain/entities/song/song_entity.dart';
import '../../items/station_item.dart';

class StationList extends StatelessWidget {
  final List<SongEntity> song;
  final List<StationEntity> stations;
  final int initialIndex;

  const StationList({super.key, required this.stations, required this.initialIndex, required this.song});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: stations.length,
        itemBuilder: (context, index) {
          final station = stations[index];

          return StationItem(station: station, initialIndex: initialIndex, song: song);
        },
      ),
    );
  }
}
