import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maestro/domain/usecases/song/get_news_songs_use_case.dart';
import 'package:maestro/features/home/bloc/videos_state.dart';
import '../../../service_locator.dart';
import 'concerts_state.dart';

class ConcertsCubit extends Cubit<ConcertsState> {

  ConcertsCubit() : super(ConcertsLoading());

  Future<void> getConcerts() async {
    var returnedSongs = await sl <GetNewsSongsUseCase> ().call();
    returnedSongs.fold(
      (l) {
        emit(ConcertsLoadFailure());
      },
      (data) {
        emit(
          ConcertsLoaded(concerts: data)
        );
      }
    );
  }
}
