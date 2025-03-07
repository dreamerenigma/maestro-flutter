import 'package:dartz/dartz.dart';
import 'package:maestro/domain/repository/song/songs_repository.dart';
import '../../../service_locator.dart';
import '../../../utils/usecase/usecase.dart';

class AddOrRemoveFavoriteSongsUseCase implements UseCase<Either, String> {

  @override
  Future<Either> call({String ? params}) async {
    return await sl<SongsRepository>().addOrRemoveFavoriteSongs(params!);
  }
}
