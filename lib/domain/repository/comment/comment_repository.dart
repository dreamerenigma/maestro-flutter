import 'package:dartz/dartz.dart';
import '../../../data/models/comment/comment_model.dart';

abstract class CommentRepository {
  Future<Either<String, CommentModel>> addComment(CommentModel comment);
  Future<Either<String, bool>> deleteComment(String commentId, String songId);
}
