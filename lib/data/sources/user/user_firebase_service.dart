import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../features/home/models/user_model.dart';

abstract class UserFirebaseService {
  Future<Either<String, UserModel>> getUserDetails(String id);
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
      );

      return Right(user);
    } catch (e) {
      return Left('Error getting user details: $e');
    }
  }
}
