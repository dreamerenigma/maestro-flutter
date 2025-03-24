import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:maestro/routes/custom_page_route.dart';
import '../../../../../../domain/entities/station/station_entity.dart';
import '../../../../domain/entities/song/song_entity.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../screens/library/station/station_screen.dart';
import '../dialogs/station_bottom_dialog.dart';

class StationItem extends StatelessWidget {
  final List<SongEntity> song;
  final StationEntity station;
  final int initialIndex;

  const StationItem({super.key, required this.station, required this.initialIndex, required this.song});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, createPageRoute(StationScreen(initialIndex: initialIndex, station: station, song: song, user: [])));
      },
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 8, top: 10, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: AppColors.darkGrey,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()), width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: station.cover,
                  width: 65,
                  height: 65,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(station.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, height: 1.2)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.favorite, color: AppColors.lightGrey, size: 14),
                      const SizedBox(width: 4),
                      Text('${station.likesCount}', style: const TextStyle(fontSize: 13, fontFamily: 'Roboto')),
                      const SizedBox(width: 4),
                      const Text('· ', style: TextStyle(color: AppColors.grey, fontSize: AppSizes.fontSizeSm)),
                      Text('${station.type} station', style: const TextStyle(fontSize: 13, fontFamily: 'Roboto')),
                      Text(' · ', style: TextStyle(color: AppColors.grey, fontSize: AppSizes.fontSizeSm)),
                      Text('${station.trackCount} Tracks', style: const TextStyle(fontSize: 13, fontFamily: 'Roboto')),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert_rounded, size: 22, color: AppColors.grey),
              onPressed: () {
                showStationBottomDialog(context, station, showCopyPlaylist: false, showShufflePlay: false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
