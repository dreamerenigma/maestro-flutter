import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../models/comment/comment_model.dart';

abstract class CommentFirebaseService {
  Future<Either<String, CommentModel>> addComment(CommentModel comment);
  Future<Either<String, bool>> deleteComment(String commentId, String songId);
  Future<Either<String, CommentModel>> getCommentRef(CommentModel comment);
  Future<Either<String, List<CommentModel>>> getComments(String songId);
  Future<Either<String, List<CommentModel>>> getLikeComments(String songId, String userId);
  Future<Either<String, bool>> addReactionToComment(String commentId, String songId, String reaction, String userId);
}

class CommentFirebaseServiceImpl extends CommentFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<String, CommentModel>> addComment(CommentModel comment) async {
    try {
      var commentsRef = _firestore.collection('Songs').doc(comment.songId).collection('Comments');
      var newCommentRef = await commentsRef.add(comment.toMap());
      var addedComment = comment.copyWith(commentId: newCommentRef.id);

      return Right(addedComment);
    } catch (e) {
      return Left('Error adding comment: $e');
    }
  }

  @override
  Future<Either<String, bool>> deleteComment(String commentId, String songId) async {
    try {
      var commentDocRef = _firestore
        .collection('Songs')
        .doc(songId)
        .collection('Comments')
        .doc(commentId);

      var docSnapshot = await commentDocRef.get();
      if (docSnapshot.exists) {
        await commentDocRef.delete();
        return Right(true);
      } else {
        return Left('Comment not found');
      }
    } catch (e) {
      return Left('Error deleting comment: $e');
    }
  }

  @override
  Future<Either<String, CommentModel>> getCommentRef(CommentModel comment) async {
    try {
      var docSnapshot = await _firestore
        .collection('Songs')
        .doc(comment.songId)
        .collection('Comments')
        .doc(comment.commentId)
        .get();

      if (docSnapshot.exists) {
        var commentData = CommentModel.fromMap(docSnapshot.data()!);
        return Right(commentData);
      } else {
        return Left('Comment not found');
      }
    } catch (e) {
      return Left('Error fetching comment: $e');
    }
  }

  @override
  Future<Either<String, List<CommentModel>>> getComments(String songId) async {
    try {
      var snapshot = await _firestore
        .collection('Songs')
        .doc(songId)
        .collection('Comments')
        .get();

      List<CommentModel> comments = snapshot.docs.map((doc) => CommentModel.fromMap(doc.data())).toList();

      return Right(comments);
    } catch (e) {
      return Left('Error fetching comments: $e');
    }
  }

  @override
  Future<Either<String, List<CommentModel>>> getLikeComments(String songId, String userId) async {
    try {
      var snapshot = await _firestore
        .collection('Songs')
        .doc(songId)
        .collection('Comments')
        .get();

      List<CommentModel> comments = snapshot.docs
        .map((doc) => CommentModel.fromMap(doc.data()))
        .toList();

      List<CommentModel> likeComments = comments.where((comment) {
        var reactions = comment.reactions;

        // Check if the reactions map contains a 'like' reaction for the user
        return reactions.containsKey(userId) && reactions[userId] == 'like';
      }).toList();

      return Right(likeComments);
    } catch (e) {
      return Left('Error fetching like comments: $e');
    }
  }

  @override
  Future<Either<String, bool>> addReactionToComment(
  String commentId, String songId, String reaction, String userId) async {
  try {
    var commentDocRef = _firestore
        .collection('Songs')
        .doc(songId)
        .collection('Comments')
        .doc(commentId);

    var commentSnapshot = await commentDocRef.get();
    var commentData = commentSnapshot.data();
    log('Comment data: $commentData');

    // Handle reactions as a list
    var reactions = List<Map<String, dynamic>>.from(commentData?['reactions'] ?? []);

    // Check if the user already has a reaction
    var userReactionIndex = reactions.indexWhere((r) => r['userId'] == userId);

    if (userReactionIndex != -1) {
      // If the reaction exists, remove it
      reactions.removeAt(userReactionIndex);
    } else {
      // If the reaction doesn't exist, add the new reaction
      reactions.add({'userId': userId, 'reaction': reaction});
    }

    // Update Firestore with the new reactions list
    await commentDocRef.update({'reactions': reactions});

    return Right(true);
  } catch (e) {
    return Left('Error adding or removing reaction: $e');
  }
}
}
