import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maestro/domain/entities/playlist/playlist_entity.dart';
import 'package:maestro/features/library/bloc/playlist/playlist_state.dart';
import '../../../../domain/usecases/playlist/get_play_list_use_cases.dart';
import '../../../../service_locator.dart';

class PlaylistCubit extends Cubit<PlaylistState> {
  bool hasDataLoaded = false;

  PlaylistCubit() : super(PlaylistLoading(isLoading: true));

  Future<void> getPlaylist() async {
    if (hasDataLoaded) {
      return;
    }

    emit(PlaylistLoading(isLoading: true));

    var returnedPlaylist = await sl<GetPlaylistUseCase>().call();
    returnedPlaylist.fold(
      (failure) {
        emit(PlaylistLoadFailure());
      },
      (playlist) {
        hasDataLoaded = true;
        emit(PlaylistLoaded(playlist: playlist));
      },
    );
  }

  void setPlaylist(PlaylistEntity playlist) {
    emit(PlaylistLoaded(playlist: playlist));
  }

  void clearPlaylist() {
    emit(PlaylistInitial());
  }
}
