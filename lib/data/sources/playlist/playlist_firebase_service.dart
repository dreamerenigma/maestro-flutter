import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import '../../../domain/usecases/playlist/is_favorite_playlist.dart';
import '../../../service_locator.dart';
import '../../models/playlist/playlist_model.dart';

abstract class PlaylistFirebaseService {
  Future<Either<Exception, List<PlaylistModel>>> getPlayList();
  Future<Either<Exception, String>> createPlaylist(String title, bool isPublic);
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

        bool isFavorite = await sl<IsFavoritePlaylistUseCase>().call(
            params: element.reference.id
        );

        playlistModel = playlistModel.copyWith(
          id: element.reference.id,
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
}
