import '../../../../../domain/entities/song/song_entity.dart';

abstract class LikesState {}

class LikesLoading extends LikesState {
  final bool isLoading;

  LikesLoading({this.isLoading = true});
}

class LikesLoaded extends LikesState {
  final List<SongEntity> songs;
  LikesLoaded({required this.songs});
}

class LikesLoadFailure extends LikesState {}
