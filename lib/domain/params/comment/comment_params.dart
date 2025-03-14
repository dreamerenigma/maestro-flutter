class CommentParams {
  final String commentId;
  final String songId;
  final String authorComment;
  final String message;
  final double trackPosition;
  final DateTime timestamp;
  final String? replyToCommentId;
  final List<String> reactions;

  CommentParams({
    required this.commentId,
    required this.songId,
    required this.authorComment,
    required this.message,
    required this.trackPosition,
    required this.timestamp,
    this.replyToCommentId,
    required this.reactions,
  });
}
