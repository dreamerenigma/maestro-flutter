import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/concerts/get_concerts_use_case.dart';
import '../../../service_locator.dart';
import 'concerts_state.dart';

class ConcertsCubit extends Cubit<ConcertsState> {

  ConcertsCubit() : super(ConcertsLoading());

  Future<void> getConcerts() async {
    var returnedConcerts = await sl <GetConcertsUseCase> ().call();
    returnedConcerts.fold(
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
