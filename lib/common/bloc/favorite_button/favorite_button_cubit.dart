import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maestro/common/bloc/favorite_button/favorite_button_state.dart';
import 'package:maestro/domain/usecases/song/add_or_remove_favorite_song_use_cases.dart';
import '../../../service_locator.dart';

class FavoriteButtonCubit extends Cubit<FavoriteButtonState> {
  FavoriteButtonCubit() : super(FavoriteButtonInitial());

  void favoriteButtonUpdated(String songId, int currentLikeCount) async {
    var result = await sl<AddOrRemoveFavoriteSongsUseCase>().call(params: songId);

    result.fold(
      (l) {
        log("Error: $l");
      },
      (isFavorite) async {
        var songSnapshot = await FirebaseFirestore.instance.collection('Songs').doc(songId).get();
        if (songSnapshot.exists) {
          var songData = songSnapshot.data() as Map<String, dynamic>;

          emit(FavoriteButtonUpdated(
            isFavorite: isFavorite,
            likeCount: songData['likeCount'],
          ));
        } else {
          log("Song not found after update.");
        }
      },
    );
  }

  void loadInitialState(bool isFavorite, int likeCount) {
    emit(FavoriteButtonUpdated(isFavorite: isFavorite, likeCount: likeCount));
  }
}
