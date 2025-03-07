class LikeEntity {
  final String title;
  final String artist;
  final num duration;
  final bool isFavorite;
  final String songId;
  final int listenCount;

  LikeEntity({
    required this.title,
    required this.artist,
    required this.duration,
    required this.isFavorite,
    required this.songId,
    required this.listenCount,
  });
}
