import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:maestro/domain/entities/playlist/playlist_entity.dart';
import 'package:maestro/features/library/bloc/playlist/playlist_state.dart';
import '../../../../domain/params/playlist/playlist_params.dart';
import '../../../../domain/usecases/playlist/get_play_list_use_cases.dart';
import '../../../../domain/usecases/playlist/update_playlist_use_cases.dart';
import '../../../../service_locator.dart';

class PlaylistCubit extends Cubit<PlaylistState> {
  PlaylistCubit() : super(PlaylistInitial());

  Future<void> loadPlaylist(String id) async {
    emit(PlaylistLoading(isLoading: true));

    var returnedPlaylist = await sl<GetPlaylistUseCase>().call(params: id);
    returnedPlaylist.fold(
      (failure) {
        log('Failed to load playlist: $failure');
        Get.snackbar('Error', 'Failed to load playlist');
        emit(PlaylistLoadFailure());
      },
      (playlist) {
        log('Successfully loaded playlist: $playlist');
        emit(PlaylistLoaded(playlist: playlist));
      },
    );
  }

  Future<void> updatePlaylist(PlaylistEntity updatedPlaylist) async {
    emit(PlaylistLoading(isLoading: true));

    final params = PlaylistParams(
      id: updatedPlaylist.id,
      authorName: updatedPlaylist.authorName,
      title: updatedPlaylist.title,
      description: updatedPlaylist.description,
      coverImage: updatedPlaylist.coverImage,
      trackCount: updatedPlaylist.trackCount,
      tags: updatedPlaylist.tags,
      isPublic: updatedPlaylist.isPublic,
    );

    var result = await sl<UpdatePlaylistUseCases>().call(params: params);
    result.fold(
      (failure) {
        Get.snackbar('Error', 'Failed to update playlist');
        emit(PlaylistLoadFailure());
      },
      (success) {
        loadPlaylist(updatedPlaylist.id);
      },
    );
  }

  void clearPlaylist() {
    emit(PlaylistInitial());
  }
}
