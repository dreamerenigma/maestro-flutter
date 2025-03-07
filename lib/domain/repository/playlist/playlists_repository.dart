import 'package:dartz/dartz.dart';
import '../../../data/models/playlist/playlist_model.dart';

abstract class PlaylistsRepository {
  Future<Either<Exception, List<PlaylistModel>>> getPlaylist();
  Future<Either<Exception, String>> createPlaylist(String title, bool isPublic);
  Future<Either<Exception, String>> addOrRemoveFavoritePlaylists(String songId);
  Future<Either<Exception, List<PlaylistModel>>> getNewsPlaylists();
  Future<bool> isFavoritePlaylist(String songId);
}
