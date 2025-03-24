import '../../../domain/entities/station/station_entity.dart';

class StationModel {
  final String stationId;
  final String title;
  final String cover;
  final String authorName;
  final Duration duration;
  final bool isFavorite;
  final int likesCount;
  final int trackCount;
  final String type;

  StationModel({
    required this.stationId,
    required this.title,
    required this.cover,
    required this.authorName,
    required this.duration,
    required this.isFavorite,
    required this.likesCount,
    required this.trackCount,
    required this.type,
  });

  StationEntity toEntity() {
    return StationEntity(
      stationId: stationId,
      title: title,
      cover: cover,
      authorName: authorName,
      duration: duration,
      isFavorite: isFavorite,
      likesCount: likesCount,
      trackCount: trackCount,
      type: type,
    );
  }

  factory StationModel.fromJson(Map<String, dynamic> json) {
    try {
      return StationModel(
        stationId: json['stationId'] as String,
        title: json['title'] as String,
        cover: json['cover'] as String,
        authorName: json['authorName'] as String,
        duration: Duration(seconds: json['duration'] as int),
        isFavorite: json['isFavorite'] as bool,
        likesCount: json['likesCount'] as int,
        trackCount: json['trackCount'] as int,
        type: json['type'] as String,
      );
    } catch (e) {
      throw FormatException('Error parsing StationModel from JSON: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'stationId': stationId,
      'title': title,
      'cover': cover,
      'authorName': authorName,
      'duration': duration.inSeconds,
      'isFavorite': isFavorite,
      'likesCount': likesCount,
      'trackCount': trackCount,
      'type': type,
    };
  }
}
