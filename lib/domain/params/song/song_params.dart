class SongParams {
  final String songId;
  final String cover;
  final String title;
  final String genre;
  final String description;
  final String caption;
  final bool isPublic;

  SongParams({
    required this.songId,
    required this.cover,
    required this.title,
    required this.genre,
    required this.description,
    required this.caption,
    required this.isPublic,
  });
}
