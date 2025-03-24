import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestro/domain/entities/user/user_entity.dart';
import '../../../../data/services/user/user_firebase_service.dart';
import '../../../../service_locator.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_colors.dart';

void showBlockUserDialog(BuildContext context, UserEntity? userEntity, RxBool isBlocked) {
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
                      Text(isBlocked.value ? 'Unblock user?' : 'Block user?', style: TextStyle(fontSize: AppSizes.fontSizeBg)),
                      const SizedBox(height: 20),
                      Text(isBlocked.value
                        ? 'They will now be able to follow and interact with you and your content. We won\'t let them know that you have unblocked them.'
                        : 'This user will no longer be able to follow or interact with you, and you will not see notifications from them.'
                      ),
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
                                User? user = FirebaseAuth.instance.currentUser;

                                if (user == null) {
                                  return;
                                }

                                final result = isBlocked.value
                                    ? await sl<UserFirebaseService>().unblockUser(user.uid, userEntity!.id)
                                    : await sl<UserFirebaseService>().blockUser(user.uid, userEntity!.id);

                                result.fold(
                                  (exception) {
                                    Get.snackbar('Error', 'Failed to ${isBlocked.value ? 'unblock' : 'block'} user: $exception', snackPosition: SnackPosition.TOP);
                                  },
                                  (successMessage) {
                                    Get.snackbar('Success', '${isBlocked.value ? 'Unblocked' : 'Blocked'} user successfully', snackPosition: SnackPosition.TOP);
                                    isBlocked.value = !isBlocked.value;
                                  }
                                );
                              } catch (e) {
                                Get.snackbar('Error', 'Failed to ${isBlocked.value ? 'unblock' : 'block'} user: $e', snackPosition: SnackPosition.TOP);
                              }
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.red,
                              backgroundColor: AppColors.red.withAlpha((0.2 * 255).toInt()),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Text(
                              isBlocked.value ? 'Unblock' : 'Block',
                              style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeMd),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    right: -15,
                    top: -12,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop(false);
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
