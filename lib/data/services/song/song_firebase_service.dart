import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:maestro/domain/entities/song/song_entity.dart';
import '../../../domain/usecases/song/is_favorite_song_use_cases.dart';
import '../../../service_locator.dart';
import '../../models/song/song_model.dart';

abstract class SongFirebaseService {
  Future<Either> getNewsSongs();
  Future<Either> getSong();
  Future<Either> addOrRemoveFavoriteSongs(String songId);
  Future<bool> isFavoriteSong(String songId);
  Future<Map<String, dynamic>?> getSongDetails(String songId);
  Future<void> incrementListenCount(String songId);
  Future<Either<Exception, String>> deleteSong(String songId);
  Future<Either<Exception, String>> updateSong(String songId, String cover, String title, String genre, String description, String caption, bool isPublic);
}

class SongFirebaseServiceImpl extends SongFirebaseService {

  @override
  Future<Either<dynamic, List<SongEntity>>> getNewsSongs() async {
    try {
      List<SongEntity> songs = [];
      var data = await FirebaseFirestore.instance.collection('Songs')
        .orderBy('releaseDate', descending: true)
        .limit(3)
        .get();

      for (var element in data.docs) {
        var songModel = SongModel.fromJson(element.data());
        bool isFavorite = await sl<IsFavoriteSongUseCase>().call(
            params: element.reference.id
        );
        songModel.isFavorite = isFavorite;
        songModel.songId = element.reference.id;
        songs.add(songModel.toEntity());
      }

      return Right(songs);
    } catch (e) {
      Logger().e(e);
      return const Left('An error occurred, Please try again.');
    }
  }

  @override
  Future<Either<dynamic, List<SongEntity>>> getSong() async {
    try {
      List<SongEntity> songs = [];
      var data = await FirebaseFirestore.instance.collection('Songs')
        .orderBy('releaseDate', descending: true)
        .get();

      for (var element in data.docs) {
        var songModel = SongModel.fromJson(element.data());
        bool isFavorite = await sl<IsFavoriteSongUseCase>().call(params: element.reference.id);
        songModel.isFavorite = isFavorite;
        songModel.songId = element.reference.id;
        songs.add(songModel.toEntity());
      }

      return Right(songs);
    } catch (e) {
      Logger().e(e);
      return const Left('An error occurred, Please try again.');
    }
  }

  @override
  Future<Either<dynamic, bool>> addOrRemoveFavoriteSongs(String songId) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      late bool isFavorite;
      var user = firebaseAuth.currentUser;
      String uId = user!.uid;

      QuerySnapshot favoriteSongs = await firebaseFirestore.collection('Users')
        .doc(uId)
        .collection('Favorites')
        .where('songId', isEqualTo: songId)
        .get();

      if (favoriteSongs.docs.isNotEmpty) {
        await favoriteSongs.docs.first.reference.delete();
        isFavorite = false;
      } else {
        DocumentSnapshot songSnapshot = await firebaseFirestore.collection('Songs').doc(songId).get();
        if (songSnapshot.exists) {
          var songData = songSnapshot.data() as Map<String, dynamic>;

          await firebaseFirestore.collection('Users')
            .doc(uId)
            .collection('Favorites')
            .add({
              'songId': songId,
              'title': songData['title'],
              'artist': songData['artist'],
              'duration': songData['duration'],
              'addedDate': Timestamp.now(),
            });

          isFavorite = true;

          await firebaseFirestore.collection('Songs').doc(songId).update({
            'likeCount': FieldValue.increment(1),
          });
        } else {
          return const Left('Song not found');
        }
      }

      return Right(isFavorite);
    } catch (e) {
      Logger().e(e);
      return const Left('An error occurred');
    }
  }

  @override
  Future<bool> isFavoriteSong(String songId) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      var user = firebaseAuth.currentUser;
      String uId = user!.uid;

      QuerySnapshot favoriteSongs = await firebaseFirestore.collection('Users')
        .doc(uId)
        .collection('Favorites')
        .where('songId', isEqualTo: songId)
        .get();

      if (favoriteSongs.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Logger().e(e);
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>?> getSongDetails(String songId) async {
    try {
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      DocumentSnapshot songSnapshot = await firebaseFirestore.collection('Songs').doc(songId).get();

      if (songSnapshot.exists) {
        return songSnapshot.data() as Map<String, dynamic>?;
      } else {
        return null;
      }
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  @override
  Future<void> incrementListenCount(String songId) async {
    try {
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      DocumentReference songRef = firebaseFirestore.collection('Songs').doc(songId);

      await firebaseFirestore.runTransaction((transaction) async {
        DocumentSnapshot songSnapshot = await transaction.get(songRef);

        if (songSnapshot.exists) {
          int newListenCount = (songSnapshot['listenCount'] ?? 0) + 1;
          transaction.update(songRef, {'listenCount': newListenCount});
        }
      });
    } catch (e) {
      Logger().e(e);
    }
  }

  @override
  Future<Either<Exception, String>> deleteSong(String songId) async {
    try {
      await FirebaseFirestore.instance.collection('Songs').doc(songId).delete();
      return Right('Song deleted successfully');
    } catch (e) {
      return Left(Exception('Failed to delete song: $e'));
    }
  }

  @override
  Future<Either<Exception, String>> updateSong(String songId, String cover, String title, String genre, String description, String caption, bool isPublic) async {
    try {
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      Map<String, dynamic> data = {
        'cover': cover,
        'title': title,
        'genre': genre,
        'description': description,
        'caption': caption,
        'isPublic': isPublic,
      };

      await firebaseFirestore.collection('Songs').doc(songId).update(data);

      return Right('Song updated successfully');
    } catch (e) {
      return Left(Exception('Failed to update song: $e'));
    }
  }
}
