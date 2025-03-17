import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/services/user/user_firebase_service.dart';
import '../../../../domain/params/user/user_params.dart';
import '../../../../service_locator.dart';
import '../../../../utils/constants/app_colors.dart';

class FollowButton extends StatelessWidget {
  final int initialIndex;
  final RxBool isFollowing;
  final UserParams? userParams;

  const FollowButton({
    super.key,
    required this.initialIndex,
    required this.isFollowing,
    this.userParams,
  });

  void _handleFollowButtonPress() async {
    if (userParams == null) {
      log('Error: userParams is null.');
      return;
    }

    try {
      await sl<UserFirebaseService>().addFollowing(isFollowing, userParams!.currentUserId, userParams!.targetUserId);
    } catch (e) {
      log('Error while following/unfollowing: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => SizedBox(
        height: 38,
        child: ElevatedButton(
          onPressed: () {
            _handleFollowButtonPress();
            isFollowing.value = !isFollowing.value;
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isFollowing.value
              ? (context.isDarkMode ? AppColors.darkGrey : AppColors.lightGrey)
              : (context.isDarkMode ? AppColors.white : AppColors.black),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            side: BorderSide.none,
            elevation: 0,
          ),
          child: Text(
            isFollowing.value ? 'Following' : 'Follow',
            style: TextStyle(color: isFollowing.value
              ? (context.isDarkMode ? AppColors.white : AppColors.black)
              : (context.isDarkMode ? AppColors.black : AppColors.white),
            ),
          ),
        ),
      ),
    );
  }
}
