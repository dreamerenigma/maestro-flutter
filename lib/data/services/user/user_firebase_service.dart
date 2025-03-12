import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../domain/entities/song/recommended_entity.dart';
import '../../../domain/entities/song/song_entity.dart';
import '../../../features/home/models/user_model.dart';

abstract class UserFirebaseService {
  Future<Either<String, UserModel>> getUserDetails(String id);
  Future<Either<String, bool>> updateUserDetails(String id, Map<String, dynamic> updatedData);
  Future<Either<String, bool>> updateUserPreferences(String id, Map<String, dynamic> preferences);
  Future<Either<String, List<SongEntity>>> getRecommendedTracks(String id);
  Future<Either<String, List<SongEntity>>> createRecommendedCollection(String id);
}

class UserFirebaseServiceImpl extends UserFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<String, UserModel>> getUserDetails(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('Users').doc(id).get();

      if (!doc.exists) {
        return Left('User not found');
      }

      var data = doc.data() as Map<String, dynamic>;

      final user = UserModel(
        id: data['id'] ?? '',
        name: data['name'] ?? '',
        image: data['image'] ?? '',
        bio: data['bio'] ?? '',
        city: data['city'] ?? '',
        country: data['country'] ?? '',
        flag: data['flag'] ?? '',
        backgroundImage: data['backgroundImage'] ?? '',
        followers: data['followers'] ?? 0,
        links: [],
        limitUploads: data['country'] ?? '',
        tracksCount: data['tracksCount'] ?? 0,
      );

      return Right(user);
    } catch (e) {
      return Left('Error getting user details: $e');
    }
  }

  @override
  Future<Either<String, bool>> updateUserDetails(String id, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('Users').doc(id).update(updatedData);
      return Right(true);
    } catch (e) {
      return Left('Error updating user details: $e');
    }
  }

  @override
  Future<Either<String, bool>> updateUserPreferences(String id, Map<String, dynamic> preferences) async {
    try {
      await _firestore
        .collection('Users')
        .doc(id)
        .collection('UserPreferences')
        .doc('preferences')
        .set({
        'favoriteGenres': preferences['favoriteGenres'],
        'listenedSongs': preferences['listenedSongs'],
      });

      return Right(true);
    } catch (e) {
      return Left('Error updating preferences: $e');
    }
  }

  @override
  Future<Either<String, List<SongEntity>>> getRecommendedTracks(String id) async {
    try {
      var userSnapshot = await _firestore.collection('Users').doc(id).get();

      if (!userSnapshot.exists) {
        return Left('User not found');
      }

      List<String> genres = List<String>.from(userSnapshot.data()?['favoriteGenres'] ?? []);
      List<String> listenedSongs = List<String>.from(userSnapshot.data()?['listenedSongs'] ?? []);

      if (genres.isEmpty && listenedSongs.isEmpty) {
        return Left('No preferences found for the user.');
      }

      var recommendedSnapshot = await _firestore
        .collection('Songs')
        .where('genre', whereIn: genres)
        .where('isFavorite', isEqualTo: true)
        .limit(10)
        .get();

      var listenedSnapshot = await _firestore
        .collection('Songs')
        .where('songId', whereIn: listenedSongs)
        .get();

      var combinedSnapshot = [
        ...recommendedSnapshot.docs,
        ...listenedSnapshot.docs,
      ];

      List<SongEntity> recommendedTracks = combinedSnapshot.map((doc) => SongEntity.fromFirestore(doc)).toList();

      return Right(recommendedTracks);
    } catch (e) {
      return Left('Error fetching recommended tracks: $e');
    }
  }

  @override
  Future<Either<String, List<SongEntity>>> createRecommendedCollection(String id) async {
    try {
      var userSnapshot = await _firestore.collection('Users').doc(id).get();

      if (!userSnapshot.exists) {
        return Left('User not found');
      }

      List<String> genres = List<String>.from(userSnapshot.data()?['favoriteGenres'] ?? []);
      List<String> listenedSongs = List<String>.from(userSnapshot.data()?['listenedSongs'] ?? []);

      List<String> recommendedSongIds = [];

      if (genres.isNotEmpty) {
        var recommendedSnapshot = await _firestore
          .collection('Songs')
          .where('genre', whereIn: genres)
          .where('isFavorite', isEqualTo: true)
          .limit(10)
          .get();

        recommendedSongIds.addAll(recommendedSnapshot.docs.map((doc) => doc.id).toList());
      }

      if (listenedSongs.isNotEmpty) {
        var listenedSnapshot = await _firestore
          .collection('Songs')
          .where('songId', whereIn: listenedSongs)
          .get();

        recommendedSongIds.addAll(listenedSnapshot.docs.map((doc) => doc.id).toList());
      }

      List<SongEntity> recommendedTracks = [];
      for (String songId in recommendedSongIds) {
        var songDoc = await _firestore.collection('Songs').doc(songId).get();
        if (songDoc.exists) {
          var song = SongEntity.fromFirestore(songDoc);
          recommendedTracks.add(song);
        }
      }

      RecommendedEntity recommendedEntity = RecommendedEntity(id: id, recommendedSongIds: recommendedSongIds);

      await _firestore
        .collection('Users')
        .doc(id)
        .collection('Recommended')
        .doc('recommendations')
        .set(recommendedEntity.toMap());

      return Right(recommendedTracks);
    } catch (e) {
      return Left('Error creating recommended collection: $e');
    }
  }
}
