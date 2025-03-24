import 'package:dartz/dartz.dart';
import '../../../data/models/station/station_model.dart';
import '../../../domain/repository/station/station_repository.dart';
import '../../../service_locator.dart';
import '../../../utils/usecase/usecase.dart';

class GetStationUseCases implements UseCase<Either<String, List<StationModel>>, StationModel> {

  @override
  Future<Either<String, List<StationModel>>> call({StationModel? params}) async {
    if (params == null) {
      return Left("StationModel cannot be null");
    }
    return await sl<StationRepository>().getStations();
  }
}
