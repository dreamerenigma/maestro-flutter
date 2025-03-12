import 'package:dartz/dartz.dart';
import 'package:maestro/domain/repository/song/songs_repository.dart';
import '../../../service_locator.dart';
import '../../services/song/song_firebase_service.dart';

class SongRepositoryImpl extends SongsRepository {

  @override
  Future<Either> getNewsSongs() async {
    return await sl<SongFirebaseService>().getNewsSongs();
  }

  @override
  Future<Either> getSong() async {
    return await sl<SongFirebaseService>().getSong();
  }

  @override
  Future<Either> addOrRemoveFavoriteSongs(String songId) async {
    return await sl<SongFirebaseService>().addOrRemoveFavoriteSongs(songId);
  }

  @override
  Future<bool> isFavoriteSong(String songId) async {
    return await sl<SongFirebaseService>().isFavoriteSong(songId);
  }

  @override
  Future<Either<Exception, String>> deleteSong(String songId) async {
    return await sl<SongFirebaseService>().deleteSong(songId);
  }

  @override
  Future<Either<Exception, String>> updateSong(String songId, String cover, String title, String genre, String description, String caption, bool isPublic) async {
    return await sl<SongFirebaseService>().updateSong(songId, cover, title, genre, description, caption, isPublic);
  }
}
