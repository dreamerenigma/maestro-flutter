import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maestro/common/bloc/favorite_button/favorite_button_state.dart';
import 'package:maestro/domain/usecases/song/add_or_remove_favorite_song.dart';
import '../../../service_locator.dart';

class FavoriteButtonCubit extends Cubit<FavoriteButtonState> {
  FavoriteButtonCubit() : super(FavoriteButtonInitial());

  void favoriteButtonUpdated(String songId) async {
    var result = await sl<AddOrRemoveFavoriteSongsUseCase>().call(
      params: songId,
    );

    result.fold(
      (l) {},
      (isFavorite) {
        emit(FavoriteButtonUpdated(isFavorite: isFavorite));
      }
    );
  }
}