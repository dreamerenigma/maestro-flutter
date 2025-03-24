import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/services/playlist/playlist_firebase_service.dart';
import '../../../../service_locator.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_colors.dart';

void showDeletePlaylistDialog(BuildContext context, String playlistId, Function() onPlaylistDeleted) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Align(
          alignment: Alignment.center,
          child: Material(
            borderRadius: BorderRadius.circular(20),
            color: context.isDarkMode ? AppColors.youngNight : AppColors.light,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: BoxDecoration(color: context.isDarkMode ? AppColors.youngNight : AppColors.light, borderRadius: BorderRadius.circular(25)),
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Delete playlist?', style: TextStyle(fontSize: AppSizes.fontSizeBg)),
                      const SizedBox(height: 20),
                      const Text('This will permanently delete this playlist. Are you sure want to continue?'),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              try {
                                final result = await sl<PlaylistFirebaseService>().deletePlaylist(playlistId);

                                result.fold(
                                  (exception) {
                                    Get.snackbar('Error', 'Failed to delete playlist: $exception', snackPosition: SnackPosition.TOP);
                                  },
                                  (successMessage) {
                                    Get.snackbar('Success', 'Playlist deleted successfully', snackPosition: SnackPosition.TOP);
                                    onPlaylistDeleted();
                                  }
                                );
                              } catch (e) {
                                Get.snackbar('Error', 'Failed to delete playlist: $e', snackPosition: SnackPosition.TOP);
                              }
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.red,
                              backgroundColor: AppColors.red.withAlpha((0.2 * 255).toInt()),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            child: const Text('Delete', style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeMd)),
                          ),
                        ],
                      ),
                    ],
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
            ),
          ),
        ),
      );
    },
  );
}
