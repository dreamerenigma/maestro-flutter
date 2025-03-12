import 'package:dartz/dartz.dart';
import 'package:maestro/features/home/models/user_model.dart';
import '../../entities/song/song_entity.dart';

abstract class UserRepository {
  Future<Either<String, UserModel>> getUserDetails(String id);
  Future<Either<String, bool>> updateUserDetails(String id, Map<String, dynamic> updatedData);
  Future<Either<String, bool>> updateUserPreferences(String id, Map<String, dynamic> preferences);
  Future<Either<String, List<SongEntity>>> getRecommendedTracks(String id);
  Future<Either<String, List<SongEntity>>> createRecommendedCollection(String id);
}
