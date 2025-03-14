import 'package:cloud_firestore/cloud_firestore.dart';

abstract class CommentEntity {
  final String commentId;
  final String songId;
  final String authorComment;
  final String comment;
  final double trackPosition;
  final Timestamp timeAgo;
  final String? replyToCommentId;
  final Map<String, String> reactions;

  const CommentEntity({
    required this.commentId,
    required this.songId,
    required this.authorComment,
    required this.comment,
    required this.trackPosition,
    required this.timeAgo,
    required this.replyToCommentId,
    required this.reactions,
  });
}
