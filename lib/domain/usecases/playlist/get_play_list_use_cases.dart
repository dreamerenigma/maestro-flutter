import 'package:dartz/dartz.dart';
import '../../../service_locator.dart';
import '../../../utils/usecase/usecase.dart';
import '../../repository/playlist/playlists_repository.dart';

class GetPlaylistUseCase implements UseCase<Either, dynamic> {

  @override
  Future<Either> call({params}) async {
    return await sl<PlaylistsRepository>().getPlaylist();
  }
}
