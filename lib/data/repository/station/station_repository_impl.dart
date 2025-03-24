import 'package:dartz/dartz.dart';
import 'package:maestro/data/services/station/station_firebase_service.dart';
import '../../../domain/repository/station/station_repository.dart';
import '../../../service_locator.dart';
import '../../models/station/station_model.dart';

class StationRepositoryImpl extends StationRepository {
  @override
  Future<Either<String, StationModel>> createStation(StationModel stationModel) async {
    return await sl<StationFirebaseService>().createStation(stationModel);
  }

  @override
  Future<Either<String, List<StationModel>>> getStations() async {
    return await sl<StationFirebaseService>().getStations();
  }
}
