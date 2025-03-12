import 'package:dartz/dartz.dart';
import '../../../service_locator.dart';
import '../../../utils/usecase/usecase.dart';
import '../../params/song/song_params.dart';
import '../../repository/song/songs_repository.dart';

class DeleteSongUseCases implements UseCase<Either<Exception, String>, SongParams> {
  @override
  Future<Either<Exception, String>> call({SongParams? params}) async {
    if (params == null) {
      return Left(Exception('Params cannot be null'));
    }
    return await sl<SongsRepository>().deleteSong(params.songId);
  }
}

