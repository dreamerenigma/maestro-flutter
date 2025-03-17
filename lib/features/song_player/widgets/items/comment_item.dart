import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestro/features/library/screens/profile_settings_screen.dart';
import 'package:maestro/routes/custom_page_route.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:maestro/domain/entities/comment/comment_entity.dart';
import 'package:maestro/utils/constants/app_sizes.dart';
import '../../../../api/apis.dart';
import '../../../../data/services/comment/comment_firebase_service.dart';
import '../../../../service_locator.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/formatters/formatter.dart';
import '../dialogs/edit_comment_dialog.dart';

class CommentItem extends StatefulWidget {
  final int initialIndex;
  final CommentEntity comment;

  const CommentItem({super.key, required this.comment, required this.initialIndex});

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  late Future<Map<String, dynamic>?> userDataFuture;

  String formatReleaseDate(dynamic releaseDate) {
    if (releaseDate != null && releaseDate is Timestamp) {
      try {
        final date = releaseDate.toDate();
        timeago.setLocaleMessages('ru_short', timeago.RuShortMessages());
        return timeago.format(date, locale: 'ru_short');
      } catch (e) {
        return 'Invalid date format';
      }
    } else {
      return 'Date not available';
    }
  }

  @override
  void initState() {
    super.initState();
    userDataFuture = APIs.fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: userDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox.shrink();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No data available'));
        }

        final userData = snapshot.data!;
        final userImage = userData['image'] as String?;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    color: AppColors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, createPageRoute(ProfileSettingsScreen(initialIndex: widget.initialIndex)));
                      },
                      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: AppColors.steelGrey.withAlpha((0.4 * 255).toInt()), width: 1),
                        ),
                        child: CircleAvatar(
                          maxRadius: 20,
                          backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.lightGrey,
                          backgroundImage: userImage != null ? NetworkImage(userImage) : null,
                          child: userImage == null ? const Icon(Icons.person, size: 22) : null,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('${widget.comment.authorComment} at ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(width: 2),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(color: AppColors.darkGrey, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(30)),
                              child: Text(Formatter.formatTrackPosition(widget.comment.trackPosition),
                                style: TextStyle(color: AppColors.blue, fontSize: AppSizes.fontSizeLm, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(' · ', style: TextStyle(color: AppColors.grey, fontSize: AppSizes.fontSizeLg, fontWeight: FontWeight.bold)),
                            ),
                            Text(formatReleaseDate(widget.comment.timeAgo), style: TextStyle(color: AppColors.grey, fontSize: AppSizes.fontSizeLm)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(widget.comment.comment, style: const TextStyle(fontSize: AppSizes.fontSizeSm, height: 1)),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () async {
                                final commentService = sl<CommentFirebaseService>();
                                final userId = FirebaseAuth.instance.currentUser?.uid;

                                if (userId == null) {
                                  log('User not logged in');
                                  return;
                                }

                                final result = await commentService.addReactionToComment(widget.comment.commentId, widget.comment.songId, 'like', userId);

                                result.fold(
                                  (error) => log('Error adding reaction: $error'),
                                  (success) {
                                    setState(() {
                                      if (widget.comment.reactions.containsKey(userId)) {
                                        widget.comment.reactions.remove(userId);
                                      } else {
                                        widget.comment.reactions[userId] = 'like';
                                      }
                                    });
                                  },
                                );
                              },
                              splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                              highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                              borderRadius: BorderRadius.circular(50),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Builder(
                                      builder: (context) {
                                        final userId = FirebaseAuth.instance.currentUser?.uid;
                                        if (userId == null) {
                                          return SizedBox.shrink();
                                        }
                                        return Icon(
                                          widget.comment.reactions.containsKey(userId) && widget.comment.reactions[userId] == 'like'
                                            ? Icons.favorite_rounded
                                            : Icons.favorite_border_rounded,
                                          color: widget.comment.reactions.containsKey(userId) && widget.comment.reactions[userId] == 'like'
                                            ? AppColors.primary
                                            : AppColors.grey,
                                          size: 18,
                                        );
                                      },
                                    ),
                                    widget.comment.reactions.values.where((reaction) => reaction == 'like').isNotEmpty
                                      ? Text(
                                          widget.comment.reactions.values.where((reaction) => reaction == 'like').length.toString(),
                                          style: TextStyle(color: AppColors.white.withAlpha((0.8 * 255).toInt()), fontSize: AppSizes.fontSizeSm),
                                        )
                                      : SizedBox.shrink(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {},
                              splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                              highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12, top: 12, bottom: 12),
                                child: Text('Reply', style: TextStyle(color: context.isDarkMode ? AppColors.white : AppColors.black, fontSize: AppSizes.fontSizeSm)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              icon: Icon(
                                Icons.more_vert_rounded,
                                size: 20,
                                color: Theme.of(context).brightness == Brightness.dark ? AppColors.white : AppColors.black,
                              ),
                              onPressed: () {
                                showEditCommentDialog(context, widget.comment, userData, initialIndex: widget.initialIndex);
                              },
                            ),
                            widget.comment.reactions.values.where((reaction) => reaction == 'like').isNotEmpty
                              ? Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.all(color: AppColors.steelGrey.withAlpha((0.4 * 255).toInt()), width: 1),
                                      ),
                                      child: CircleAvatar(
                                        maxRadius: 9,
                                        backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.lightGrey,
                                        backgroundImage: userImage != null ? NetworkImage(userImage) : null,
                                        child: userImage == null ? const Icon(Icons.person, size: 22) : null,
                                      ),
                                    ),
                                    Positioned(
                                      right: -5,
                                      top: 5,
                                      child: const Text('❤️', style: TextStyle(fontSize: 8)),
                                    ),
                                  ],
                                )
                              : SizedBox.shrink(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
