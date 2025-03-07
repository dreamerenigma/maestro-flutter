import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maestro/domain/usecases/song/get_news_songs_use_case.dart';
import 'package:maestro/features/home/bloc/videos_state.dart';
import '../../../service_locator.dart';

class VideosCubit extends Cubit<VideosState> {

  VideosCubit() : super(VideosLoading());

  Future<void> getVideos() async {
    var returnedSongs = await sl <GetNewsSongsUseCase> ().call();
    returnedSongs.fold(
      (l) {
        emit(VideosLoadFailure());
      },
      (data) {
        emit(
          VideosLoaded(videos: data)
        );
      }
    );
  }
}
