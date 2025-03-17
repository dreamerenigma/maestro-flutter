import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/song/song_entity.dart';

class SongModel {
  String ? title;
  String ? artist;
  String ? genre;
  String ? description;
  String ? caption;
  num ? duration;
  Timestamp ? releaseDate;
  bool ? isFavorite;
  String ? songId;
  int ? listenCount;
  int ? likeCount;
  int ? commentsCount;
  int ? repostCount;
  String ? fileURL;
  String? uploadedBy;

  SongModel({
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
    required this.repostCount,
    required this.fileURL,
    required this.uploadedBy,
  });

  SongModel.fromJson(Map<String, dynamic> data) {
    title = data['title'];
    artist = data['artist'];
    genre = data['genre'];
    duration = data['description'];
    duration = data['caption'];
    duration = data['duration'];
    releaseDate = data['releaseDate'];
    isFavorite = data['isFavorite'];
    songId = data['songId'];
    listenCount = data['listenCount'] ?? 0;
    likeCount = data['likeCount'] ?? 0;
    commentsCount = data['commentsCount'] ?? 0;
    repostCount = data['repostCount'] ?? 0;
    fileURL = data['fileURL'];
    uploadedBy = data['uploadedBy'];
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'artist': artist,
      'genre': genre,
      'description': description,
      'caption': caption,
      'duration': duration,
      'releaseDate': releaseDate,
      'isFavorite': isFavorite,
      'songId': songId,
      'listenCount': listenCount,
      'likeCount': likeCount,
      'commentsCount': commentsCount,
      'repostCount': repostCount,
      'fileURL': fileURL,
      'uploadedBy': uploadedBy,
    };
  }
}

extension SongModelX on SongModel {
  SongEntity toEntity() {
    return SongEntity(
      title: title!,
      artist: artist!,
      genre: genre!,
      description: description!,
      caption: caption!,
      duration: duration!,
      releaseDate: releaseDate!,
      isFavorite: isFavorite!,
      songId: songId!,
      listenCount: listenCount!,
      likeCount: likeCount!,
      commentsCount: commentsCount!,
      repostCount: repostCount!,
      fileURL: '',
      cover: '',
      uploadedBy: uploadedBy ?? '',
    );
  }
}
