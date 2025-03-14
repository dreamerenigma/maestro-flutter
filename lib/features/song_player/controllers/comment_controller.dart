import 'package:get/get.dart';
import 'package:maestro/domain/entities/comment/comment_entity.dart';

class CommentController extends GetxController {
  RxList<CommentEntity> comments = <CommentEntity>[].obs;

  void addComment(CommentEntity comment) {
    comments.add(comment);
  }
}

