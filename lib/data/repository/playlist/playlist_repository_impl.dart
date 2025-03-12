import 'package:dartz/dartz.dart';
import '../../../domain/repository/playlist/playlists_repository.dart';
import '../../../service_locator.dart';
import '../../models/playlist/playlist_model.dart';
import '../../services/playlist/playlist_firebase_service.dart';

class PlaylistRepositoryImpl extends PlaylistsRepository {

  @override
  Future<Either<Exception, List<PlaylistModel>>> getPlaylist() async {
    return await sl<PlaylistFirebaseService>().getPlayList();
  }

  @override
  Future<Either<Exception, String>> createPlaylist(String title, bool isPublic) async {
    return await sl<PlaylistFirebaseService>().createPlaylist(title, isPublic);
  }

  @override
  Future<Either<Exception, String>> updatePlaylist(String playlistId, String title, String description, String coverImage, int trackCount, List<String> tags, bool isPublic) async {
    return await sl<PlaylistFirebaseService>().updatePlaylist(playlistId, title, description, coverImage, trackCount, tags, isPublic);
  }

  @override
  Future<Either<Exception, String>> deletePlaylist(String playlistId) async {
    return await sl<PlaylistFirebaseService>().deletePlaylist(playlistId);
  }

  @override
  Future<Either<Exception, String>> addOrRemoveFavoritePlaylists(String playlistId) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, List<PlaylistModel>>> getNewsPlaylists() async {
    throw UnimplementedError();
  }

  @override
  Future<bool> isFavoritePlaylist(String playlistId) async {
    throw UnimplementedError();
  }
}

