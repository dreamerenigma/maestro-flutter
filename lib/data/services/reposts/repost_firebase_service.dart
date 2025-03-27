import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../models/repost/repost_model.dart';

abstract class RepostFirebaseService {
  Future<Either<String, RepostModel>> addRepost(String userId, String targetId, String targetType);
}

class RepostFirebaseServiceImpl extends RepostFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<String, RepostModel>> addRepost(String userId, String targetId, String targetType) async {
    try {
      var repostRef = _firestore.collection('Reposts').doc();

      var repostData = {
        'userId': userId,
        'targetId': targetId,
        'targetType': targetType,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await repostRef.set(repostData);

      var repostModel = RepostModel(
        repostId: repostRef.id,
        userId: userId,
        targetId: targetId,
        type: targetType,
        createdAt: DateTime.now(),
      );

      return Right(repostModel);
    } catch (e) {
      return Left('Error adding repost: $e');
    }
  }
}
