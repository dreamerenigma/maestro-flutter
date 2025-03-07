import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maestro/domain/usecases/song/get_play_list.dart';
import '../../../service_locator.dart';
import 'likes_state.dart';

class LikesCubit extends Cubit<LikesState> {
  bool hasDataLoaded = false;

  LikesCubit() : super(LikesLoading(isLoading: true));

  Future<void> getLikes() async {
    if (hasDataLoaded) {
      return;
    }

    emit(LikesLoading(isLoading: true));

    var returnedSongs = await sl <GetPlayListUseCase> ().call();
    returnedSongs.fold(
        (l) {
          emit(LikesLoadFailure());
        },
        (data) {
          hasDataLoaded = true;
          emit(LikesLoaded(songs: data));
        }
    );
  }
}
