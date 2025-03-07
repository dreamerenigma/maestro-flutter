import '../../../domain/entities/song/song_entity.dart';

abstract class ConcertsState {}

class ConcertsLoading extends ConcertsState {}

class ConcertsLoaded extends ConcertsState {
  final List<SongEntity> concerts;
  ConcertsLoaded({required this.concerts});
}

class ConcertsLoadFailure extends ConcertsState {}
