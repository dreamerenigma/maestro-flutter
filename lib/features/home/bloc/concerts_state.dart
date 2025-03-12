import 'package:maestro/features/home/models/concert_model.dart';

abstract class ConcertsState {}

class ConcertsLoading extends ConcertsState {}

class ConcertsLoaded extends ConcertsState {
  final List<ConcertModel> concerts;
  ConcertsLoaded({required this.concerts});
}

class ConcertsLoadFailure extends ConcertsState {}
