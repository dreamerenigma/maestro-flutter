import 'package:dartz/dartz.dart';
import 'package:maestro/domain/repository/comment/comment_repository.dart';
import '../../../service_locator.dart';
import '../../../utils/usecase/usecase.dart';

class DeleteCommentUseCases implements UseCase<Either<String, bool>, String> {

  @override
  Future<Either<String, bool>> call({String? params}) async {
    if (params == null) {
      return Left("Comment ID is missing");
    }
    return await sl<CommentRepository>().deleteComment(params, params);
  }
}
