import 'package:dartz/dartz.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:maestro/domain/entities/song/song_entity.dart';
import 'package:maestro/domain/repository/users/user_repository.dart';
import '../../../features/home/models/user_model.dart';
import '../../../service_locator.dart';
import '../../services/user/user_firebase_service.dart';

class UserRepositoryImpl extends UserRepository {
  @override
  Future<Either<String, UserModel>> getUserDetails(String id) async {
    return await sl<UserFirebaseService>().getUserDetails(id);
  }

  @override
  Future<Either<String, bool>> updateUserDetails(String id, Map<String, dynamic> updatedData) async {
    return await sl<UserFirebaseService>().updateUserDetails(id, updatedData);
  }

  @override
  Future<Either<String, bool>> updateUserPreferences(String id, Map<String, dynamic> preferences) async {
    return await sl<UserFirebaseService>().updateUserPreferences(id, preferences);
  }

  @override
  Future<Either<String, List<SongEntity>>> getRecommendedTracks(String id) async {
    return await sl<UserFirebaseService>().getRecommendedTracks(id);
  }

  @override
  Future<Either<String, List<SongEntity>>> createRecommendedCollection(String id) async {
    return await sl<UserFirebaseService>().createRecommendedCollection(id);
  }

  @override
  Future<Either<String, bool>> addFollowing(RxBool isFollowing, String currentUserId, String targetUserId) async {
    return await sl<UserFirebaseService>().addFollowing(isFollowing, currentUserId, targetUserId);
  }
}
