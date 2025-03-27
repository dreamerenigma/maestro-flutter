import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maestro/domain/entities/playlist/playable_item.dart';
import '../../../data/models/playlist/playlist_model.dart';
import '../../../utils/formatters/formatter.dart';

class PlaylistEntity implements PlayableItem {
  final String id;
  final String title;
  final String authorName;
  final String description;
  final Timestamp releaseDate;
  final bool isFavorite;
  final int listenCount;
  final String coverImage;
  final int likes;
  final int trackCount;
  final List<String> tags;
  final bool isPublic;

  PlaylistEntity({
    required this.id,
    required this.title,
    required this.authorName,
    required this.description,
    required this.releaseDate,
    required this.isFavorite,
    required this.listenCount,
    required this.coverImage,
    required this.likes,
    required this.trackCount,
    required this.tags,
    required this.isPublic,
  });

  PlaylistEntity copyWith({
    String? id,
    String? title,
    String? authorName,
    String? description,
    Timestamp? releaseDate,
    bool? isFavorite,
    int? listenCount,
    String? coverImage,
    int? likes,
    int? trackCount,
    List<String>? tags,
    bool? isPublic,
  }) {
    return PlaylistEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      authorName: authorName ?? this.authorName,
      description: description ?? this.description,
      releaseDate: releaseDate ?? this.releaseDate,
      isFavorite: isFavorite ?? this.isFavorite,
      listenCount: listenCount ?? this.listenCount,
      coverImage: coverImage ?? this.coverImage,
      likes: likes ?? this.likes,
      trackCount: trackCount ?? this.trackCount,
      tags: tags ?? this.tags,
      isPublic: isPublic ?? this.isPublic,
    );
  }

  factory PlaylistEntity.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    final duration = data['duration'] is String ? Formatter.parseDuration(data['duration']) : data['duration'] ?? 0;

    log('Fetched Duration for ${doc.id}: $duration');

    return PlaylistEntity(
      id: doc.id,
      title: data['title'] ?? 'Unknown Title',
      authorName: data['authorName'] ?? 'Unknown Author Name',
      description: data['description'] ?? '',
      releaseDate: data['releaseDate'] ?? Timestamp.now(),
      isFavorite: data['isFavorite'] ?? false,
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
      id: model.id,
      title: model.title,
      authorName: model.authorName,
      description: '',
      releaseDate: Timestamp.now(),
      isFavorite: model.isFavorite,
      listenCount: 0,
      coverImage: '',
      likes: model.likes,
      trackCount: model.trackCount,
      tags: model.tags,
      isPublic: model.isPublic,
    );
  }
}
