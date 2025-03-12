import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/station/station_model.dart';

abstract class StationFirebaseService {
  Future<Either<String, StationModel>> createStation(StationModel stationModel);
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
        'stationId': stationModel.stationId,
        'authorName': stationModel.authorName,
        'duration': stationModel.duration.inSeconds,
        'isFavorite': stationModel.isFavorite,
        'likesCount': stationModel.likesCount,
      });

      final createdStation = StationModel(
        stationId: stationDocRef.id,
        authorName: stationModel.authorName,
        duration: stationModel.duration,
        isFavorite: stationModel.isFavorite,
        likesCount: stationModel.likesCount,
      );

      return Right(createdStation);
    } catch (e) {
      return Left('Error creating station: $e');
    }
  }
}
