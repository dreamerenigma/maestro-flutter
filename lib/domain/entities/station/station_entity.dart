class StationEntity {
  final String stationId;
  final String authorName;
  final Duration duration;
  final bool isFavorite;
  final int likesCount;

  StationEntity({
    required this.stationId,
    required this.authorName,
    required this.duration,
    required this.isFavorite,
    required this.likesCount,
  });

  factory StationEntity.fromJson(Map<String, dynamic> json) {
    return StationEntity(
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
