import '../../../service_locator.dart';
import '../../../utils/usecase/usecase.dart';
import '../../repository/playlist/playlists_repository.dart';

class IsFavoritePlaylistUseCase implements UseCase<bool, String> {

  @override
  Future<bool> call({String ? params}) async {
    return await sl<PlaylistsRepository>().isFavoritePlaylist(params!);
  }
}
