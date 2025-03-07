class PlaylistModel {
  final String id;
  final String title;
  final String author;
  final int likes;
  final int trackCount;
  final bool isFavorite;

  PlaylistModel({
    required this.id,
    required this.title,
    required this.author,
    required this.likes,
    required this.trackCount,
    this.isFavorite = false,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      likes: json['likes'] ?? 0,
      trackCount: json['trackCount'] as int,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'likes': likes,
      'trackCount': trackCount,
      'isFavorite': isFavorite,
    };
  }

  PlaylistModel copyWith({
    String? id,
    String? title,
    String? author,
    int? likes,
    int? trackCount,
    bool? isFavorite,
  }) {
    return PlaylistModel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      likes: likes ?? this.likes,
      trackCount: trackCount ?? this.trackCount,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
