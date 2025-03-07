import 'package:on_audio_query/on_audio_query.dart';

class SongModelWithDownloadInfo {
  final SongModel song;
  final DateTime downloadTime;

  SongModelWithDownloadInfo({
    required this.song,
    required this.downloadTime
  });
}
