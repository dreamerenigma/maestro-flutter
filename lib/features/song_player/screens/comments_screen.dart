import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jam_icons/jam_icons.dart';
import 'package:maestro/domain/entities/song/song_entity.dart';
import 'package:maestro/features/library/screens/library/tracks/behind_this_track_screen.dart';
import 'package:maestro/routes/custom_page_route.dart';
import '../../../api/apis.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../data/models/comment/comment_model.dart';
import '../../../data/services/comment/comment_firebase_service.dart';
import '../../../domain/entities/comment/comment_entity.dart';
import '../../../service_locator.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../controllers/comment_controller.dart';
import '../widgets/dialogs/sort_by_comments_bottom_dialog.dart';
import '../widgets/inputs/comments_text_field.dart';
import '../widgets/lists/comment_list.dart';

class CommentsScreen extends StatefulWidget {
  final int initialIndex;
  final SongEntity song;
  final List<CommentEntity> comments;

  const CommentsScreen({super.key, required this.song, this.initialIndex = 0, required this.comments});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _controller = TextEditingController();
  final CommentController commentController = Get.put(CommentController());
  late Future<Map<String, dynamic>?> userDataFuture;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    userDataFuture = APIs.fetchUserData();
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.isNotEmpty;
      });
    });

    _fetchComments();
  }

  void _clearText() {
    setState(() {
      _controller.clear();
      _hasText = false;
    });
  }

  Future<void> _fetchComments() async {
    try {
      final result = await sl<CommentFirebaseService>().getComments(widget.song.songId);

      result.fold(
        (error) {
          log("Error loading comments: $error");
          Get.snackbar("Error", "Unable to load comments", backgroundColor: AppColors.red);
        },
        (comments) {
          setState(() {
            commentController.comments.value = comments.map((commentModel) {
              return CommentModel(
                commentId: commentModel.commentId,
                songId: commentModel.songId,
                authorComment: commentModel.authorComment,
                comment: commentModel.comment,
                trackPosition: commentModel.trackPosition,
                timeAgo: commentModel.timeAgo,
                reactions: commentModel.reactions,
                replyToCommentId: commentModel.replyToCommentId,
              );
            }).toList();
          });
        },
      );
    } catch (error) {
      log("Error loading comments: $error");
      Get.snackbar("Error", "Unable to load comments", backgroundColor: AppColors.red);
    }
  }

  void _onSendPressed() async {
    if (_controller.text.trim().isEmpty) return;

    final userData = await userDataFuture;
    final userName = userData?['name'] as String? ?? "Unknown User";
    final authorName = userName;

    log('Preparing to send comment:');
    log('Comment Text: ${_controller.text.trim()}');
    log('Author Name: $authorName');
    log('Song ID: ${widget.song.songId}');

    var commentDocRef = FirebaseFirestore.instance.collection('Songs').doc(widget.song.songId).collection('Comments').doc();

    String commentId = commentDocRef.id;

    final newComment = CommentModel(
      commentId: commentId,
      songId: widget.song.songId,
      authorComment: authorName,
      comment: _controller.text.trim(),
      trackPosition: 0.0,
      timeAgo: Timestamp.now(),
      reactions: {},
      replyToCommentId: '',
    );

    try {
      await commentDocRef.set({
        'commentId': commentId,
        'songId': widget.song.songId,
        'authorComment': authorName,
        'comment': _controller.text.trim(),
        'trackPosition': 0.0,
        'timeAgo': Timestamp.now(),
        'reactions': [],
        'replyToCommentId': '',
      });

      log('Added Comment with ID: $commentId');

      final updatedComment = newComment.copyWith(commentId: commentId);
      log('Updated Comment: ${updatedComment.toMap()}');

      setState(() {
        widget.comments.add(updatedComment);
      });

      commentController.addComment(newComment);

      final songRef = FirebaseFirestore.instance.collection('Songs').doc(widget.song.songId);
      await songRef.update({
        'commentsCount': FieldValue.increment(1),
      });

      _controller.clear();
    } catch (error) {
      log("Error: $error");
      Get.snackbar("Error", error.toString(), backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: Text(
          '${widget.song.commentsCount} ${widget.song.commentsCount == 1 ? 'comment' : 'comments'}',
          style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        showCloseIcon: true,
        actions: [
          IconButton(
            onPressed: () => showSortByCommentsBottomDialog(context),
            icon: Icon(JamIcons.settingsAlt, size: 26),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }
          final userData = snapshot.data!;

          return Stack(
            children: [
              Column(
                children: [
                  _buildTrackInfo(context),
                  Divider(height: 10, color: AppColors.darkGrey),
                  _buildReactions(),
                  Divider(height: 2, color: AppColors.darkGrey),
                  CommentList(comments: commentController.comments, initialIndex: widget.initialIndex),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SizedBox(
                  width: double.infinity,
                  child: _buildCommentTextField(userData),
                ),
              ),
              if (commentController.comments.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: Text(
                      'This track doesn\'t have any comments. \nBe the first!',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTrackInfo(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, createPageRoute(BehindThisTrackScreen(song: widget.song, initialIndex: widget.initialIndex)));
      },
      splashColor: context.isDarkMode ? AppColors.darkGrey.withAlpha((0.4 * 255).toInt()) : AppColors.grey.withAlpha((0.4 * 255).toInt()),
      highlightColor: context.isDarkMode ? AppColors.darkGrey.withAlpha((0.4 * 255).toInt()) : AppColors.grey.withAlpha((0.4 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.cardRadiusXs),
                border: Border.all(color: AppColors.steelGrey, width: 0.5),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    widget.song.cover,
                  ),
                ),
              ),
            ),
            SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 101),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      widget.song.title,
                      style: const TextStyle(color: AppColors.white, fontSize: 15, fontWeight: FontWeight.bold, height: 1, letterSpacing: -0.5),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Text(widget.song.uploadedBy, style: const TextStyle(fontSize: 13, color: AppColors.buttonGrey, fontWeight: FontWeight.w400)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReactions() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 60,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 60,
                  child: Container(
                    padding: EdgeInsets.all(7),
                    decoration: BoxDecoration(color: AppColors.youngNight, shape: BoxShape.circle, border: Border.all(color: AppColors.backgroundColor, width: 2)),
                    child: Text('🥺', style: TextStyle(fontSize: AppSizes.fontSizeSm)),
                  ),
                ),
                Positioned(
                  left: 30,
                  child: Container(
                    padding: EdgeInsets.all(7),
                    decoration: BoxDecoration(color: AppColors.youngNight, shape: BoxShape.circle, border: Border.all(color: AppColors.backgroundColor, width: 2)),
                    child: Text('👏', style: TextStyle(fontSize: AppSizes.fontSizeSm)),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(color: AppColors.youngNight, shape: BoxShape.circle, border: Border.all(color: AppColors.backgroundColor, width: 2)),
                  child: Text('🔥', style: TextStyle(fontSize: AppSizes.fontSizeSm)),
                ),
              ],
            ),
          ),
          SizedBox(width: 40),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                children: [
                  Text('0', style: TextStyle(fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.bold)),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Text(
                      '${widget.song.commentsCount} ${widget.song.commentsCount == 1 ? 'comment' : 'comments'}',
                      style: TextStyle(fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentTextField(Map<String, dynamic> userData) {
    final userImage = userData['image'] as String?;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: AppColors.steelGrey.withAlpha((0.4 * 255).toInt()),
                width: 1,
              ),
            ),
            child: CircleAvatar(
              maxRadius: 23,
              backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.lightGrey,
              backgroundImage: userImage != null ? NetworkImage(userImage) : null,
              child: userImage == null ? const Icon(Icons.person, size: 22) : null,
            ),
          ),
          SizedBox(width: 12),
          Flexible(
            child: CommentsTextField(
              controller: _controller,
              clearText: _clearText,
              hasText: _hasText,
              onSendPressed: _onSendPressed,
            ),
          ),
        ],
      ),
    );
  }
}
