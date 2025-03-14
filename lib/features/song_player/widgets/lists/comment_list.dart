import 'package:flutter/material.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import '../../../../domain/entities/comment/comment_entity.dart';
import '../items/comment_item.dart';

class CommentList extends StatelessWidget {
  final int initialIndex;
  final List<CommentEntity> comments;

  const CommentList({super.key, required this.comments, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 50),
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final comment = comments[index];

            return CommentItem(comment: comment, initialIndex: initialIndex);
          },
        ),
      ),
    );
  }
}
