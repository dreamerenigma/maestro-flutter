import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/station/station_model.dart';

abstract class StationFirebaseService {
  Future<Either<String, StationModel>> createStation(StationModel stationModel);
  Future<Either<String, List<StationModel>>> getStations();
  Future<Either<String, List<StationModel>>> addLikeStation(String stationId);
}

class StationFirebaseServiceImpl extends StationFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<String, StationModel>> createStation(StationModel stationModel) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('No user logged in');
      }

      final stationsRef = _firestore.collection('Users').doc(user.uid).collection('Stations');

      final stationDocRef = await stationsRef.add({
        'stationId': '',
        'title': stationModel.title,
        'cover': stationModel.cover,
        'authorName': stationModel.authorName,
        'duration': stationModel.duration.inSeconds,
        'isFavorite': stationModel.isFavorite,
        'likesCount': stationModel.likesCount,
        'trackCount': stationModel.trackCount,
      });

      final createdStation = StationModel(
        stationId: stationDocRef.id,
        title: stationModel.title,
        cover: stationModel.cover,
        authorName: stationModel.authorName,
        duration: stationModel.duration,
        isFavorite: stationModel.isFavorite,
        likesCount: stationModel.likesCount,
        trackCount: stationModel.trackCount,
        type: stationModel.type,
      );

      return Right(createdStation);
    } catch (e) {
      return Left('Error creating station: $e');
    }
  }

  @override
  Future<Either<String, List<StationModel>>> getStations() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('No user logged in');
      }

      final stationsRef = _firestore.collection('Users').doc(user.uid).collection('Stations');
      final snapshot = await stationsRef.get();

      if (snapshot.docs.isEmpty) {
        return Left('No stations found');
      }

      List<StationModel> stations = snapshot.docs.map((doc) {
        var data = doc.data();

        return StationModel(
          stationId: doc.id,
          title: data['title'] ?? '',
          cover: data['cover'] ?? '',
          authorName: data['authorName'] ?? '',
          duration: Duration(seconds: data['duration'] ?? 0),
          isFavorite: data['isFavorite'] ?? false,
          likesCount: data['likesCount'] ?? 0,
          trackCount: data['trackCount'] ?? 0,
          type: data['type'] ?? '',
        );
      }).toList();

      return Right(stations);
    } catch (e) {
      return Left('Error fetching stations: $e');
    }
  }

  @override
  Future<Either<String, List<StationModel>>> addLikeStation(String stationId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Left('No user logged in');
    }

    final stationRef = FirebaseFirestore.instance.collection('Users').doc(user.uid).collection('Stations').doc(stationId);

    final stationDoc = await stationRef.get();

    if (!stationDoc.exists) {
      return Left('Station not found');
    }

    int currentLikes = stationDoc.data()?['likesCount'] ?? 0;
    bool isLiked = stationDoc.data()?['likedBy']?.contains(user.uid) ?? false;

    if (isLiked) {
      await stationRef.update({
        'likesCount': currentLikes > 0 ? currentLikes - 1 : 0,
        'likedBy': FieldValue.arrayRemove([user.uid])
      });
    } else {
      await stationRef.update({
        'likesCount': currentLikes + 1,
        'likedBy': FieldValue.arrayUnion([user.uid])
      });
    }

    return Right([]);
  }
}
