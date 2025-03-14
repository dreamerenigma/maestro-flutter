import 'package:dartz/dartz.dart';
import 'package:maestro/data/models/comment/comment_model.dart';
import 'package:maestro/domain/repository/comment/comment_repository.dart';
import '../../../service_locator.dart';
import '../../../utils/usecase/usecase.dart';

class AddCommentUseCases implements UseCase<Either<String, CommentModel>, CommentModel> {

  @override
  Future<Either<String, CommentModel>> call({CommentModel? params}) async {
    if (params == null) {
      return Left("User ID cannot be null");
    }
    return await sl<CommentRepository>().addComment(params);
  }
}
