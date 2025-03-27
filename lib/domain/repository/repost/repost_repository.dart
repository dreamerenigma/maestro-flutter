import 'package:dartz/dartz.dart';
import '../../../data/models/repost/repost_model.dart';

abstract class RepostRepository {
  Future<Either<String, RepostModel>> addRepost(String userId, String targetId, String targetType);
}
