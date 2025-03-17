import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:maestro/features/library/screens/profile_settings_screen.dart';
import 'package:maestro/routes/custom_page_route.dart';
import 'package:mono_icons/mono_icons.dart';
import '../../../../data/services/comment/comment_firebase_service.dart';
import '../../../../domain/entities/comment/comment_entity.dart';
import '../../../../service_locator.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

void showEditCommentDialog(BuildContext context, CommentEntity comment, Map<String, dynamic> userData, {required int initialIndex}) {
  final int initialIndex = 0;
  final userName = userData['name'] as String?;

  showModalBottomSheet(
    context: context,
    enableDrag: true,
    showDragHandle: false,
    isScrollControlled: true,
    backgroundColor: context.isDarkMode ? AppColors.backgroundColor : AppColors.lightBackground,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
    builder: (BuildContext context) {
      return SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 4,
              width: 38,
              decoration: BoxDecoration(color: context.isDarkMode ? AppColors.white : AppColors.black, borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.only(top: 10, bottom: 6),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('$userName at 0:00', style: TextStyle(fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.normal, letterSpacing: -0.3)),
                ],
              ),
            ),
            SizedBox(height: 5),
            Column(
              children: [
                _buildCommentOption('Play from 0:00', Bootstrap.play_circle, () {

                }),
                _buildCommentOption('Go to profile', FeatherIcons.user, () {
                  Navigator.pushReplacement(context, createPageRoute(ProfileSettingsScreen(initialIndex: initialIndex)));
                }),
                _buildCommentOption('Copy', PhosphorIcons.copy_light, () {
                  Navigator.pop(context);
                  Clipboard.setData(ClipboardData(text: comment.comment));
                  Get.snackbar("Copied", "Comment copied to clipboard");
                }),
                _buildCommentOption('Delete comment', MonoIcons.delete, () async {
                  final commentService = sl<CommentFirebaseService>();
                  final result = await commentService.deleteComment(comment.commentId, comment.songId);

                  result.fold(
                    (error) {
                      Get.snackbar("Error", error);
                    },
                    (success) {
                      Navigator.pop(context);
                      Get.snackbar("Deleted", "Comment successfully deleted");
                    },
                  );
                }),
                SizedBox(height: 12),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildCommentOption(String text, IconData icon, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
    highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.grey, size: 22),
          SizedBox(width: 12),
          Text(text, style: TextStyle(color: AppColors.grey, fontSize: AppSizes.fontSizeMd)),
        ],
      ),
    ),
  );
}
