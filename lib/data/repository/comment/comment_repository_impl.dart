import 'package:dartz/dartz.dart';
import 'package:maestro/data/models/comment/comment_model.dart';
import 'package:maestro/data/services/comment/comment_firebase_service.dart';
import '../../../domain/repository/comment/comment_repository.dart';
import '../../../service_locator.dart';

class CommentRepositoryImpl extends CommentRepository {

  @override
  Future<Either<String, CommentModel>> addComment(CommentModel comment) async {
    return await sl<CommentFirebaseService>().addComment(comment);
  }

  @override
  Future<Either<String, bool>> deleteComment(String commentId, String songId) async {
    return await sl<CommentFirebaseService>().deleteComment(commentId, songId);
  }
}
