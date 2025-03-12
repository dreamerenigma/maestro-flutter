import '../../../domain/entities/station/station_entity.dart';

class StationModel {
  final String stationId;
  final String authorName;
  final Duration duration;
  final bool isFavorite;
  final int likesCount;

  StationModel({
    required this.stationId,
    required this.authorName,
    required this.duration,
    required this.isFavorite,
    required this.likesCount,
  });

  StationEntity toEntity() {
    return StationEntity(
      stationId: stationId,
      authorName: authorName,
      duration: duration,
      isFavorite: isFavorite,
      likesCount: likesCount,
    );
  }

  factory StationModel.fromJson(Map<String, dynamic> json) {
    return StationModel(
      stationId: json['stationId'] as String,
      authorName: json['authorName'] as String,
      duration: Duration(seconds: json['duration'] as int),
      isFavorite: json['isFavorite'] as bool,
      likesCount: json['likesCount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stationId': stationId,
      'authorName': authorName,
      'duration': duration.inSeconds,
      'isFavorite': isFavorite,
      'likesCount': likesCount,
    };
  }
}
