import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maestro/features/library/screens/profile_settings_screen.dart';
import 'package:maestro/routes/custom_page_route.dart';
import '../../../../../../domain/entities/song/song_entity.dart';
import '../../../../../../utils/constants/app_colors.dart';
import '../../../../../../utils/constants/app_sizes.dart';
import '../../../../../../utils/formatters/formatter.dart';
import 'package:timeago/timeago.dart' as timeago;

class TrackWidget extends StatefulWidget {
  final int initialIndex;
  final SongEntity song;
  final Map<String, dynamic> userData;
  final VoidCallback? onImageTap;
  final double? imageWidth;
  final double? imageHeight;

  const TrackWidget({
    super.key,
    required this.initialIndex,
    required this.song,
    required this.userData,
    this.onImageTap,
    this.imageWidth,
    this.imageHeight,
  });

  @override
  State<TrackWidget> createState() => _TrackWidgetState();
}

class _TrackWidgetState extends State<TrackWidget> {

  String formatReleaseDate(dynamic releaseDate) {
    if (releaseDate != null && releaseDate is Timestamp) {
      try {
        final date = releaseDate.toDate();
        timeago.setLocaleMessages('ru_short', timeago.RuShortMessages());
        return timeago.format(date, locale: 'ru_short');
      } catch (e) {
        return 'Invalid date format';
      }
    } else {
      return 'Date not available';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 8, top: 12, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: widget.onImageTap,
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.darkGrey, width: 0.8)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.song.cover,
                      width: widget.imageWidth ?? 100,
                      height: widget.imageHeight ?? 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.song.title,
                    style: const TextStyle(color: AppColors.white, fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, createPageRoute(ProfileSettingsScreen(initialIndex: widget.initialIndex)));
                    },
                    splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                    highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                    child: Text(
                      widget.song.uploadedBy,
                      style: const TextStyle(color: AppColors.lightGrey, fontWeight: FontWeight.w200, fontSize: AppSizes.fontSizeMd, letterSpacing: -0.5),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.play_arrow, size: 20, color: AppColors.grey),
                      const SizedBox(width: 4),
                      Text(widget.song.listenCount.toString(), style: const TextStyle(color: AppColors.grey, fontSize: AppSizes.fontSizeSm)),
                      const SizedBox(width: 6),
                      const Text('·', style: TextStyle(color: AppColors.grey, fontSize: AppSizes.fontSizeSm)),
                      const SizedBox(width: 6),
                      Text(Formatter.formatDurationTrack(widget.song.duration.toInt()),
                        style: TextStyle(fontSize: AppSizes.fontSizeSm, fontFamily: 'Roboto', fontWeight: FontWeight.normal),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: const Text(' · ', style: TextStyle(color: AppColors.grey, fontSize: AppSizes.fontSizeSm)),
                      ),
                      Text(formatReleaseDate(widget.song.releaseDate), style: TextStyle(fontSize: AppSizes.fontSizeSm)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
