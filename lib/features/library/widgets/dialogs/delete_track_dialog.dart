import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/services/song/song_firebase_service.dart';
import '../../../../service_locator.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_colors.dart';

void showDeleteTrackDialog(BuildContext context, String songId, Function() onTrackDeleted) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        elevation: 4,
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.darkBackground : AppColors.lightBackground,
        titlePadding: const EdgeInsets.all(0),
        actionsPadding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
        contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 16),
        title: Stack(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 14, bottom: 12),
              child: Text('Delete this track?', style: TextStyle(fontSize: AppSizes.fontSizeBg)),
            ),
            Positioned(
              right: 0,
              top: 3,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
        content: const Text('Removing this track is irreversible. You will lose all activity'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: context.isDarkMode ? AppColors.darkerGrey : AppColors.buttonSecondary,
              backgroundColor: context.isDarkMode ? AppColors.darkGrey : AppColors.buttonSecondary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text('Cancel', style: TextStyle(color: context.isDarkMode ? AppColors.white : AppColors.black, fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeMd)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                final result = await sl<SongFirebaseService>().deleteSong(songId);

                result.fold(
                  (exception) {
                    Get.snackbar('Error', 'Failed to delete track: $exception', snackPosition: SnackPosition.TOP);
                  },
                  (successMessage) {
                    Get.snackbar('Success', 'Track deleted successfully', snackPosition: SnackPosition.TOP);
                    onTrackDeleted();
                  }
                );
              } catch (e) {
                Get.snackbar('Error', 'Failed to delete track: $e', snackPosition: SnackPosition.TOP);
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.red,
              backgroundColor: AppColors.red.withAlpha((0.2 * 255).toInt()),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text('Delete track', style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeMd)),
          ),
        ],
      );
    },
  );
}
