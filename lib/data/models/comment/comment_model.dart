import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/comment/comment_entity.dart';

class CommentModel extends CommentEntity {
  CommentModel({
    required super.commentId,
    required super.songId,
    required super.authorComment,
    required super.comment,
    required super.trackPosition,
    required super.timeAgo,
    required super.replyToCommentId,
    required super.reactions,
  });

  factory CommentModel.fromEntity(CommentEntity entity) {
    return CommentModel(
      commentId: entity.commentId,
      songId: entity.songId,
      authorComment: entity.authorComment,
      comment: entity.comment,
      trackPosition: entity.trackPosition,
      timeAgo: entity.timeAgo,
      replyToCommentId: entity.replyToCommentId,
      reactions: entity.reactions,
    );
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    var reactions = map['reactions'] is List
      ? { for (var item in map['reactions']) item['userId'] as String : item['reaction'] as String }
      : Map<String, String>.from(map['reactions'] ?? {});

    return CommentModel(
      commentId: map['commentId'] ?? '',
      songId: map['songId'] ?? '',
      authorComment: map['authorComment'] ?? '',
      comment: map['comment'] ?? '',
      trackPosition: map['trackPosition'] ?? 0.0,
      timeAgo: map['timeAgo'] is Timestamp ? map['timeAgo'] as Timestamp : Timestamp.now(),
      replyToCommentId: map['replyToCommentId'],
      reactions: reactions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'songId': songId,
      'authorComment': authorComment,
      'comment': comment,
      'trackPosition': trackPosition,
      'timeAgo': timeAgo,
      'replyToCommentId': replyToCommentId,
      'reactions': reactions,
    };
  }

  CommentModel copyWith({
    String? commentId,
    String? songId,
    String? authorComment,
    String? comment,
    double? trackPosition,
    Timestamp? timeAgo,
    String? replyToCommentId,
    Map<String, String>? reactions,
  }) {
    return CommentModel(
      commentId: commentId ?? this.commentId,
      songId: songId ?? this.songId,
      authorComment: authorComment ?? this.authorComment,
      comment: comment ?? this.comment,
      trackPosition: trackPosition ?? this.trackPosition,
      timeAgo: timeAgo ?? this.timeAgo,
      replyToCommentId: replyToCommentId ?? this.replyToCommentId,
      reactions: reactions ?? this.reactions,
    );
  }
}
