import 'package:dartz/dartz.dart';
import '../../../data/models/playlist/playlist_model.dart';

abstract class PlaylistsRepository {
  Future<Either<Exception, List<PlaylistModel>>> getPlaylist(String playlistId);
  Future<Either<Exception, String>> createPlaylist(String title, bool isPublic);
  Future<Either<Exception, String>> updatePlaylist(String playlistId, String title, String description, String coverImage, int trackCount, List<String> tags, bool isPublic);
  Future<Either<Exception, String>> deletePlaylist(String playlistId);
  Future<Either<Exception, String>> addOrRemoveFavoritePlaylists(String playlistId);
  Future<Either<Exception, List<PlaylistModel>>> getNewsPlaylists();
  Future<bool> isFavoritePlaylist(String playlistId);
}
