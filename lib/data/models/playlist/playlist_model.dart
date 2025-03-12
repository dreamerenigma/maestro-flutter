class PlaylistModel {
  final String playlistId;
  final String title;
  final String authorName;
  final int likes;
  final int trackCount;
  final List<String> tags;
  final bool isFavorite;
  final bool isPublic;

  PlaylistModel({
    required this.playlistId,
    required this.title,
    required this.authorName,
    required this.likes,
    required this.trackCount,
    required this.tags,
    this.isFavorite = false,
    this.isPublic = false,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      playlistId: json['playlistId'] as String,
      title: json['title'] as String,
      authorName: json['authorName'] as String,
      likes: json['likes'] ?? 0,
      trackCount: json['trackCount'] as int,
      tags: json['tags'] as List<String>,
      isFavorite: json['isFavorite'] ?? false,
      isPublic: json['isPublic'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'playlistId': playlistId,
      'title': title,
      'authorName': authorName,
      'likes': likes,
      'trackCount': trackCount,
      'tags': tags,
      'isFavorite': isFavorite,
      'isPublic': isPublic,
    };
  }

  PlaylistModel copyWith({
    String? playlistId,
    String? title,
    String? authorName,
    int? likes,
    int? trackCount,
    List<String>? tags,
    bool? isFavorite,
    bool? isPublic,
  }) {
    return PlaylistModel(
      playlistId: playlistId ?? this.playlistId,
      title: title ?? this.title,
      authorName: authorName ?? this.authorName,
      likes: likes ?? this.likes,
      trackCount: trackCount ?? this.trackCount,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
      isPublic: isPublic ?? this.isPublic,
    );
  }
}
