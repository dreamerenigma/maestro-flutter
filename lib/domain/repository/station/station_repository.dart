import 'package:dartz/dartz.dart';
import '../../../data/models/station/station_model.dart';

abstract class StationRepository {
  Future<Either<String, StationModel>> createStation(StationModel stationModel);
  Future<Either<String, List<StationModel>>> getStations();
}
