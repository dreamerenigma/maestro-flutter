import 'package:maestro/domain/repository/song/songs_repository.dart';
import '../../../service_locator.dart';
import '../../../utils/usecase/usecase.dart';

class IsFavoriteSongUseCase implements UseCase<bool, String> {

  @override
  Future<bool> call({String ? params}) async {
    return await sl<SongsRepository>().isFavoriteSong(params!);
  }
}
