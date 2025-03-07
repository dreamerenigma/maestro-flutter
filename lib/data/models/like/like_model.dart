class LikeModel {
  String ? title;
  String ? artist;
  num ? duration;
  bool ? isFavorite;
  String ? songId;
  int ? listenCount;

  LikeModel({
    required this.title,
    required this.artist,
    required this.duration,
    required this.isFavorite,
    required this.songId,
    required this.listenCount,
  });

  LikeModel.fromJson(Map<String, dynamic> data) {
    title = data['title'];
    artist = data['artist'];
    duration = data['duration'];
    listenCount = data['listenCount'];
  }
}

extension SongModelX on LikeModel {

  LikeModel toEntity() {
    return LikeModel(
      title: title!,
      artist: artist!,
      duration: duration!,
      isFavorite: isFavorite!,
      songId: songId!,
      listenCount: listenCount!,
    );
  }
}
