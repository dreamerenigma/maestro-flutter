import 'package:dartz/dartz.dart';
import '../../../data/models/station/station_model.dart';
import '../../../domain/repository/station/station_repository.dart';
import '../../../service_locator.dart';
import '../../../utils/usecase/usecase.dart';

class CreateStationUseCases implements UseCase<Either<String, StationModel>, StationModel> {

  @override
  Future<Either<String, StationModel>> call({StationModel? params}) async {
    if (params == null) {
      return Left("StationModel cannot be null");
    }
    return await sl<StationRepository>().createStation(params);
  }
}
