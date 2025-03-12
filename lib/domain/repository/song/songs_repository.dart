import 'package:dartz/dartz.dart';

abstract class SongsRepository {
  Future<Either> getNewsSongs();
  Future<Either> getSong();
  Future<Either> addOrRemoveFavoriteSongs(String songId);
  Future<bool> isFavoriteSong(String songId);
  Future<Either<Exception, String>> deleteSong(String songId);
  Future<Either<Exception, String>> updateSong(String songId, String cover, String title, String genre, String description, String caption, bool isPublic);
}
