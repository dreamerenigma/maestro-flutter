import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maestro/features/library/bloc/song/song_state.dart';
import '../../../../domain/entities/song/song_entity.dart';
import '../../../../domain/usecases/song/get_song_use_cases.dart';
import '../../../../service_locator.dart';

class SongCubit extends Cubit<SongState> {
  bool hasDataLoaded = false;

  SongCubit() : super(SongLoading(isLoading: true));

  Future<void> getSong() async {
    if (hasDataLoaded) {
      return;
    }

    emit(SongLoading(isLoading: true));

    var returnedSong = await sl<GetSongUseCase>().call();
    returnedSong.fold(
      (failure) {
        emit(SongLoadFailure());
      },
      (song) {
        hasDataLoaded = true;
        emit(SongLoaded(song: song));
      },
    );
  }

  void setSong(SongEntity song) {
    emit(SongLoaded(song: song));
  }

  void clearSong() {
    emit(SongInitial());
  }
}
