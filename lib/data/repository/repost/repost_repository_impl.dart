import 'package:dartz/dartz.dart';
import 'package:maestro/domain/repository/repost/repost_repository.dart';
import '../../../service_locator.dart';
import '../../models/repost/repost_model.dart';
import '../../services/reposts/repost_firebase_service.dart';

class RepostRepositoryImpl extends RepostRepository {
  @override
  Future<Either<String, RepostModel>> addRepost(String userId, String targetId, String targetType) async {
    return await sl<RepostFirebaseService>().addRepost(userId, targetId, targetType);
  }
}

