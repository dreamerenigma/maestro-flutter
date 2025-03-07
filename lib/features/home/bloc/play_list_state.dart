import '../../../domain/entities/song/song_entity.dart';

abstract class PlayListState {}

class PlayListLoading extends PlayListState {
  final bool isLoading;

  PlayListLoading({this.isLoading = true});
}

class PlayListLoaded extends PlayListState {
  final List<SongEntity> songs;
  PlayListLoaded({required this.songs});
}

class PlayListLoadFailure extends PlayListState {}
