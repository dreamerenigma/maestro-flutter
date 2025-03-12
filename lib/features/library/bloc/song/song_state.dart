import 'package:maestro/domain/entities/song/song_entity.dart';

abstract class SongState {}

class SongInitial extends SongState {}

class SongLoading extends SongState {
  final bool isLoading;

  SongLoading({this.isLoading = true});
}

class SongLoaded extends SongState {
  final SongEntity song;

  SongLoaded({required this.song});
}

class SongLoadFailure extends SongState {}
