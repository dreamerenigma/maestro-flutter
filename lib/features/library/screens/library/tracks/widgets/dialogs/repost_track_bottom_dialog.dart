import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../data/services/song/song_firebase_service.dart';
import '../../../../../../../domain/entities/song/song_entity.dart';
import '../../../../../../../service_locator.dart';
import '../../../../../../../utils/constants/app_colors.dart';
import '../../../../../../../utils/constants/app_sizes.dart';
import '../buttons/add_caption_button.dart';
import '../inputs/repost_text_field_widget.dart';
import '../track_widget.dart';

showRepostTrackDialog(BuildContext context, Map<String, dynamic> userData, int initialIndex, SongEntity song) {
  final userName = userData['name'] as String?;
  final userImage = userData['image'] as String?;
  final TextEditingController controller = TextEditingController();

  showModalBottomSheet(
    context: context,
    enableDrag: true,
    showDragHandle: false,
    isScrollControlled: true,
    backgroundColor: context.isDarkMode ? AppColors.backgroundColor : AppColors.lightBackground,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (BuildContext context) {
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

      return Padding(
        padding: EdgeInsets.only(bottom: keyboardHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 4,
                width: 38,
                decoration: BoxDecoration(color: context.isDarkMode ? AppColors.white : AppColors.black, borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.only(top: 10, bottom: 6),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  SizedBox(
                    height: 36,
                    child: CircleAvatar(
                      backgroundColor: AppColors.darkGrey,
                      child: IconButton(
                        icon: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: const Icon(Icons.close, color: AppColors.white, size: 22),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Repost', style: TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(color: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()), width: 1),
                            color: AppColors.darkGrey,
                          ),
                          child: CircleAvatar(
                            maxRadius: 18,
                            backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.lightGrey,
                            backgroundImage: userImage != null ? (userImage.startsWith('http') ? NetworkImage(userImage) : FileImage(File(userImage))) : null,
                            child: userImage == null ? const Icon(Icons.camera_alt_outlined, size: 30) : null,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text('$userName', style: TextStyle(fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.bold)),
                        Text(' reposted a track', style: TextStyle(color: context.isDarkMode ? AppColors.grey : AppColors.lightGrey, fontSize: 13, fontWeight: FontWeight.bold)),
                        Text(' · ', style: TextStyle(color: context.isDarkMode ? AppColors.grey : AppColors.lightGrey, fontSize: AppSizes.fontSizeLg, fontWeight: FontWeight.bold)),
                        Text('Now', style: TextStyle(color: context.isDarkMode ? AppColors.grey : AppColors.lightGrey, fontSize: 13, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            RepostTextFieldWidget(controller: controller),
            TrackWidget(song: song, userData: userData, initialIndex: initialIndex, imageWidth: 70, imageHeight: 70),
            AddCaptionButton(
              onPressed: () async {
                String songId = song.songId;
                final caption = controller.text;
                final result = await sl<SongFirebaseService>().addRepostSong(songId, caption);

                result.fold(
                  (failure) {
                    Get.snackbar('Failure', 'Failure added error!');
                  },
                  (songs) {
                    Get.snackbar('Success', 'Repost added successfully!');
                  },
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  );
}
