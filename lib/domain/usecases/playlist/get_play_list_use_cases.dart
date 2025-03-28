import 'package:dartz/dartz.dart';
import '../../../service_locator.dart';
import '../../../utils/usecase/usecase.dart';
import '../../repository/playlist/playlists_repository.dart';

class GetPlaylistUseCase implements UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    if (params == null) {
      return Left(Exception('Playlist ID cannot be null'));
    }
    return await sl<PlaylistsRepository>().getPlaylist(params);
  }
}
