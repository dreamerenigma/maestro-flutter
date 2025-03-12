import 'package:maestro/domain/repository/users/user_repository.dart';
import '../../../service_locator.dart';
import '../../../utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import '../../entities/song/song_entity.dart';

class CreateRecommendedTracksUseCase implements UseCase<Either<String, List<SongEntity>>, String> {

  @override
  Future<Either<String, List<SongEntity>>> call({String? params}) async {
    if (params == null) {
      return Left("User ID cannot be null");
    }
    return await sl<UserRepository>().createRecommendedCollection(params);
  }
}


