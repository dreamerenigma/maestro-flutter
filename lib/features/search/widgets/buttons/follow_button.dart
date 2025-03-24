import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/services/user/user_firebase_service.dart';
import '../../../../domain/entities/user/user_entity.dart';
import '../../../../domain/params/user/user_params.dart';
import '../../../../service_locator.dart';
import '../../../../utils/constants/app_colors.dart';

class FollowButton extends StatelessWidget {
  final int initialIndex;
  final RxBool isFollowing;
  final UserParams? userParams;
  final UserEntity? userEntity;

  const FollowButton({
    super.key,
    required this.initialIndex,
    required this.isFollowing,
    this.userParams,
    required this.userEntity,
  });

  void _handleFollowButtonPress() async {
    log('Follow button pressed');
    if (userParams == null) {
      log('Error: userParams is null.');
      return;
    }

    if (userEntity == null) {
      log('Error: userEntity is null.');
      return;
    }

    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return;
      }

      log('Adding following: currentUserId=${user.uid}, targetUserId=${userEntity!.id}');

      await sl<UserFirebaseService>().addFollowing(isFollowing, user.uid, userEntity!.id);
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
          log('Button pressed, isFollowing before toggle: ${isFollowing.value}');
          _handleFollowButtonPress();
          isFollowing.value = !isFollowing.value;
          log('Button pressed, isFollowing after toggle: ${isFollowing.value}');
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
    ));
  }
}
