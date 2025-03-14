import 'dart:developer';
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
  final int likeCount;
  final int commentsCount;
  final String fileURL;
  final String cover;
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
    required this.likeCount,
    required this.commentsCount,
    required this.fileURL,
    required this.cover,
    required this.uploadedBy,
  });

    factory SongEntity.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    final duration = data['duration'] is String ? parseDuration(data['duration']) : data['duration'] ?? 0;

    log('Fetched Duration for ${doc.id}: $duration');

    return SongEntity(
      title: data['title'] ?? 'Unknown Title',
      artist: data['artist'] ?? 'Unknown Artist',
      genre: data['genre'] ?? '',
      description: data['description'] ?? '',
      caption: data['caption'] ?? '',
      duration: duration,
      releaseDate: data['releaseDate'] ?? Timestamp.now(),
      isFavorite: data['isFavorite'] ?? false,
      songId: doc.id,
      listenCount: data['listenCount'] ?? 0,
      likeCount: data['likeCount'] ?? 0,
      commentsCount: data['commentsCount'] ?? 0,
      fileURL: data['fileURL'] ?? '',
      cover: data['cover'] ?? '',
      uploadedBy: data['uploadedBy'] ?? '',
    );
  }
}

Future<SongEntity> convertSongModelToEntity(SongModel songModel, {bool fetchFromFirestore = true}) async {
  int listenCount = 0;
  int likeCount = 0;
  int commentsCount = 0;

  if (fetchFromFirestore) {
    listenCount = await _fetchFieldFromFirestore(songModel.id.toString(), 'listenCount');
    likeCount = await _fetchFieldFromFirestore(songModel.id.toString(), 'likeCount');
    commentsCount = await _fetchFieldFromFirestore(songModel.id.toString(), 'commentsCount');
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
    likeCount: likeCount,
    commentsCount: commentsCount,
    fileURL: songModel.data,
    cover: '',
    uploadedBy: uploadedBy,
  );
}

Future<String> _fetchUploadedByFromFirestore(String songId) async {
  final doc = await FirebaseFirestore.instance.collection('Songs').doc(songId).get();
  return doc.exists ? (doc.data()?['uploadedBy'] ?? '') : '';
}

Future<int> _fetchFieldFromFirestore(String songId, String fieldName) async {
  final doc = await FirebaseFirestore.instance.collection('Songs').doc(songId).get();
  return doc.exists ? (doc.data()?[fieldName] ?? 0) as int : 0;
}

int parseDuration(String durationString) {
  final parts = durationString.split(':');
  if (parts.length == 2) {
    final minutes = int.tryParse(parts[0]) ?? 0;
    final seconds = int.tryParse(parts[1]) ?? 0;
    return minutes * 60 + seconds;
  }
  return 0;
}
