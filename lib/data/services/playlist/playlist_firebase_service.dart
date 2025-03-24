import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import '../../../domain/usecases/playlist/is_favorite_playlist_use_cases.dart';
import '../../../service_locator.dart';
import '../../models/playlist/playlist_model.dart';

abstract class PlaylistFirebaseService {
  Future<Either<Exception, List<PlaylistModel>>> getPlayList();
  Future<Either<Exception, String>> createPlaylist(String title, bool isPublic);
  Future<Either<Exception, String>> updatePlaylist(String playlistId, String title, String description, String coverImage, int trackCount, List<String> tags, bool isPublic);
  Future<Either<Exception, String>> deletePlaylist(String playlistId);
  Future<Either<Exception, String>> copyPlaylist(String playlistId, String title, bool isPublic);
}

class PlaylistFirebaseServiceImpl extends PlaylistFirebaseService {
  @override
  Future<Either<Exception, List<PlaylistModel>>> getPlayList() async {
    try {
      List<PlaylistModel> playlists = [];
      var data = await FirebaseFirestore.instance.collection('Playlists')
        .orderBy('releaseDate', descending: true)
        .get();

      for (var element in data.docs) {
        var playlistModel = PlaylistModel.fromJson(element.data());

        bool isFavorite = await sl<IsFavoritePlaylistUseCase>().call(params: element.reference.id);

        playlistModel = playlistModel.copyWith(
          playlistId: element.reference.id,
          isFavorite: isFavorite,
        );

        playlists.add(playlistModel);
      }

      return Right(playlists);
    } catch (e) {
      Logger().e(e);
      return Left(Exception('An error occurred, Please try again.'));
    }
  }

  @override
  Future<Either<Exception, String>> createPlaylist(String title, bool isPublic) async {
    try {
      final playlistRef = FirebaseFirestore.instance.collection('Playlists').doc();
      log('Creating playlist with ref: ${playlistRef.id}');

      var userData = await getUserAvatarAndNameFromUsersCollection();

      String? userAvatarUrl = userData['avatar'] ?? '';
      String? authorName = userData['name'] ?? '';

      Map<String, dynamic> playlistData = {
        'title': title,
        'isPublic': isPublic,
        'releaseDate': FieldValue.serverTimestamp(),
        'coverImage': userAvatarUrl,
        'authorName': authorName,
      };

      await playlistRef.set(playlistData);
      log('Playlist created with ID: ${playlistRef.id}');
      return Right(playlistRef.id);
    } catch (e) {
      Logger().e(e);
      log('Error creating playlist: $e');
      return Left(Exception('Failed to create playlist.'));
    }
  }

  Future<Map<String, String?>> getUserAvatarAndNameFromUsersCollection() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        var userDoc = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();

        if (userDoc.exists && userDoc.data() != null) {
          String? avatar = userDoc.data()!['image'];
          String? name = userDoc.data()!['name'];
          return {'avatar': avatar, 'name': name};
        }
      }
    } catch (e) {
      Logger().e('Error retrieving avatar and name from Users collection: $e');
    }
    return {'avatar': null, 'name': null};
  }

  @override
  Future<Either<Exception, String>> updatePlaylist(String playlistId, String title, String description, String coverImage, int trackCount, List<String> tags, bool isPublic) async {
    try {
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      Map<String, dynamic> data = {
        'title': title,
        'description': description,
        'coverImage': coverImage,
        'trackCount': trackCount,
        'tags': tags,
        'isPublic': isPublic,
      };

      log('Updating playlist with data: $data');

      await firebaseFirestore.collection('Playlists').doc(playlistId).update(data);

      return Right('Playlist updated successfully');
    } catch (e) {
      log('Error updating playlist: $e');
      return Left(Exception('Failed to update playlist'));
    }
  }

  @override
  Future<Either<Exception, String>> deletePlaylist(String playlistId) async {
    try {
      await FirebaseFirestore.instance.collection('Playlists').doc(playlistId).delete();
      return Right('Playlist deleted successfully');
    } catch (e) {
      return Left(Exception('Failed to delete playlist: $e'));
    }
  }

  @override
  Future<Either<Exception, String>> copyPlaylist(String playlistId, String title, bool isPublic) async {
    try {
      var playlistDoc = await FirebaseFirestore.instance.collection('Playlists').doc(playlistId).get();
      if (!playlistDoc.exists) {
        return Left(Exception('Playlist not found'));
      }

      var playlistData = playlistDoc.data();
      if (playlistData == null) {
        return Left(Exception('Failed to fetch playlist data'));
      }

      var tracksQuery = await FirebaseFirestore.instance.collection('Tracks')
        .where('playlistId', isEqualTo: playlistId)
        .get();

      List<Map<String, dynamic>> tracksData = [];
      for (var trackDoc in tracksQuery.docs) {
        tracksData.add(trackDoc.data());
      }

      final newPlaylistRef = FirebaseFirestore.instance.collection('Playlists').doc();
      Map<String, dynamic> newPlaylistData = {
        'title': playlistData['title'],
        'description': playlistData['description'],
        'coverImage': playlistData['coverImage'],
        'isPublic': playlistData['isPublic'],
        'releaseDate': FieldValue.serverTimestamp(),
        'authorName': playlistData['authorName'],
      };

      await newPlaylistRef.set(newPlaylistData);
      log('New playlist created with ID: ${newPlaylistRef.id}');

      for (var track in tracksData) {
        await FirebaseFirestore.instance.collection('Tracks').add({
          ...track,
          'playlistId': newPlaylistRef.id,
        });
      }
      log('Tracks copied to the new playlist');

      return Right(newPlaylistRef.id);

    } catch (e) {
      log('Error copying playlist: $e');
      return Left(Exception('Failed to copy playlist'));
    }
  }
}
