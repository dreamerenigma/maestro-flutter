import 'package:dartz/dartz.dart';
import '../../../service_locator.dart';
import '../../../utils/usecase/usecase.dart';
import '../../params/playlist/playlist_params.dart';
import '../../repository/playlist/playlists_repository.dart';

class CreatePlaylistUseCases implements UseCase<Either<Exception, String>, PlaylistParams> {
  @override
  Future<Either<Exception, String>> call({PlaylistParams? params}) async {
    if (params == null) {
      return Left(Exception('Params cannot be null'));
    }
    return await sl<PlaylistsRepository>().createPlaylist(params.title, params.isPublic);
  }
}
