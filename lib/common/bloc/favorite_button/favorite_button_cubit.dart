import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maestro/common/bloc/favorite_button/favorite_button_state.dart';
import 'package:maestro/domain/usecases/song/add_or_remove_favorite_song_use_cases.dart';
import '../../../service_locator.dart';

class FavoriteButtonCubit extends Cubit<FavoriteButtonState> {
  FavoriteButtonCubit() : super(FavoriteButtonInitial());

  void favoriteButtonUpdated(String songId, int currentLikeCount) async {
    var result = await sl<AddOrRemoveFavoriteSongsUseCase>().call(
      params: songId,
    );

    result.fold(
      (l) {},
      (isFavorite) {
        if (isFavorite && currentLikeCount > 0) {
          return;
        } else if (!isFavorite && currentLikeCount == 0) {
          return;
        }

        int newLikeCount = isFavorite ? currentLikeCount + 1 : currentLikeCount - 1;
        emit(FavoriteButtonUpdated(isFavorite: isFavorite, likeCount: newLikeCount));
      }
    );
  }

  void loadInitialState(bool isFavorite, int likeCount) {
    emit(FavoriteButtonUpdated(isFavorite: isFavorite, likeCount: likeCount));
  }
}
