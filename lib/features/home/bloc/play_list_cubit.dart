import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maestro/domain/usecases/song/get_play_list.dart';
import 'package:maestro/features/home/bloc/play_list_state.dart';
import '../../../service_locator.dart';

class PlayListCubit extends Cubit<PlayListState> {
  bool hasDataLoaded = false;

  PlayListCubit() : super(PlayListLoading(isLoading: true));

  Future<void> getPlayList() async {
    if (hasDataLoaded) {
      return;
    }

    emit(PlayListLoading(isLoading: true));

    var returnedSongs = await sl <GetPlayListUseCase> ().call();
    returnedSongs.fold(
        (l) {
          emit(PlayListLoadFailure());
        },
        (data) {
          hasDataLoaded = true;
          emit(PlayListLoaded(songs: data));
        }
    );
  }
}
