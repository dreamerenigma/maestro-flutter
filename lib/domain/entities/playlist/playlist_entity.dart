import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/playlist/playlist_model.dart';

abstract class PlayableItem {}

class PlaylistEntity implements PlayableItem {
  final String title;
  final String authorName;
  final String description;
  final Timestamp releaseDate;
  final bool isFavorite;
  final String playlistId;
  final int listenCount;
  final String coverImage;
  final int likes;
  final int trackCount;
  final List<String> tags;
  final bool isPublic;

  PlaylistEntity({
    required this.title,
    required this.authorName,
    required this.description,
    required this.releaseDate,
    required this.isFavorite,
    required this.playlistId,
    required this.listenCount,
    required this.coverImage,
    required this.likes,
    required this.trackCount,
    required this.tags,
    required this.isPublic,
  });

  factory PlaylistEntity.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    final duration = data['duration'] is String ? parseDuration(data['duration']) : data['duration'] ?? 0;

    log('Fetched Duration for ${doc.id}: $duration');

    return PlaylistEntity(
      title: data['title'] ?? 'Unknown Title',
      authorName: data['authorName'] ?? 'Unknown Author Name',
      description: data['description'] ?? '',
      releaseDate: data['releaseDate'] ?? Timestamp.now(),
      isFavorite: data['isFavorite'] ?? false,
      playlistId: doc.id,
      listenCount: data['listenCount'] ?? 0,
      coverImage: data['coverImage'] ?? '',
      likes: data['likes'] ?? 0,
      trackCount: data['trackCount'] ?? 0,
      tags: data['tags'] ?? List<String>,
      isPublic: data['isPublic'] ?? false,
    );
  }

  factory PlaylistEntity.fromPlaylistModel(PlaylistModel model) {
    return PlaylistEntity(
      title: model.title,
      authorName: model.authorName,
      description: '',
      releaseDate: Timestamp.now(),
      isFavorite: model.isFavorite,
      playlistId: model.playlistId,
      listenCount: 0,
      coverImage: '',
      likes: model.likes,
      trackCount: model.trackCount,
      tags: model.tags,
      isPublic: model.isPublic,
    );
  }
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
