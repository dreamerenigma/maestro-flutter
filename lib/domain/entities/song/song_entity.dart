import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongEntity {
  final String title;
  final String artist;
  final String genre;
  final String description;
  final String caption;
  final num duration;
  final Timestamp releaseDate;
  final bool isFavorite;
  final String songId;
  final int listenCount;
  final String url;
  final String coverPath;
  final String uploadedBy;

  SongEntity({
    required this.title,
    required this.artist,
    required this.genre,
    required this.description,
    required this.caption,
    required this.duration,
    required this.releaseDate,
    required this.isFavorite,
    required this.songId,
    required this.listenCount,
    required this.url,
    required this.coverPath,
    required this.uploadedBy,
  });
}

Future<SongEntity> convertSongModelToEntity(SongModel songModel, {bool fetchFromFirestore = true}) async {
  int listenCount = 0;

  if (fetchFromFirestore) {
    listenCount = await _fetchListenCountFromFirestore(songModel.id.toString());
  }

  final String uploadedBy = await _fetchUploadedByFromFirestore(songModel.id.toString());
  String description = '';
  String caption = '';

  return SongEntity(
    title: songModel.title,
    artist: songModel.artist ?? 'Unknown Artist',
    genre: songModel.genre ?? '',
    description: description,
    caption: caption,
    duration: songModel.duration ?? 0,
    releaseDate: Timestamp.now(),
    isFavorite: false,
    songId: songModel.id.toString(),
    listenCount: listenCount,
    url: songModel.data,
    coverPath: '',
    uploadedBy: uploadedBy,
  );
}

Future<String> _fetchUploadedByFromFirestore(String songId) async {
  final doc = await FirebaseFirestore.instance.collection('Songs').doc(songId).get();
  return doc.exists ? (doc.data()?['uploadedBy'] ?? '') : '';
}

Future<int> _fetchListenCountFromFirestore(String songId) async {
  final doc = await FirebaseFirestore.instance.collection('Songs').doc(songId).get();
  return doc.exists ? (doc.data()?['listenCount'] ?? 0) as int : 0;
}
