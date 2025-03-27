class PlaylistParams {
  final String id;
  final String authorName;
  final String title;
  final String description;
  final String coverImage;
  final int trackCount;
  final List<String> tags;
  final bool isPublic;

  PlaylistParams( {
    required this.id,
    required this.authorName,
    required this.title,
    required this.description,
    required this.coverImage,
    required this.trackCount,
    required this.tags,
    required this.isPublic,
  });
}
