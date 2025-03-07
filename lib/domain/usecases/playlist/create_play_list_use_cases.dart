import 'package:dartz/dartz.dart';
import '../../../service_locator.dart';
import '../../../utils/usecase/usecase.dart';
import '../../params/create_playlist_params.dart';
import '../../repository/playlist/playlists_repository.dart';

class CreatePlaylistUseCases implements UseCase<Either<Exception, String>, CreatePlaylistParams> {
  @override
  Future<Either<Exception, String>> call({CreatePlaylistParams? params}) async {
    if (params == null) {
      return Left(Exception('Params cannot be null'));
    }
    return await sl<PlaylistsRepository>().createPlaylist(params.title, params.isPublic);
  }
}
