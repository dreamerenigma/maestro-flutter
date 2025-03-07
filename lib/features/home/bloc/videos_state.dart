import '../../../domain/entities/song/song_entity.dart';

abstract class VideosState {}

class VideosLoading extends VideosState {}

class VideosLoaded extends VideosState {
  final List<SongEntity> videos;
  VideosLoaded({required this.videos});
}

class VideosLoadFailure extends VideosState {}
