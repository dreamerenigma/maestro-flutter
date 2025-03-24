import '../../../domain/entities/song/song_entity.dart';

abstract class SongPlayerState {}

class SongPlayerLoading extends SongPlayerState {}

class SongPlayerLoaded extends SongPlayerState {
  final SongEntity? currentSong;
  final List<Map<String, dynamic>> listeningHistory;

  SongPlayerLoaded(this.currentSong, this.listeningHistory);
}

class SongPlayerFailure extends SongPlayerState {
  final String errorMessage;

  SongPlayerFailure(this.errorMessage);

  List<Object?> get props => [errorMessage];
}
