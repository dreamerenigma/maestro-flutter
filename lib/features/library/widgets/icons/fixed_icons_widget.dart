import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../domain/entities/user/user_entity.dart';
import '../../../../utils/constants/app_colors.dart';
import '../dialogs/share_profile_bottom_dialog.dart';

class FixedIconsWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final UserEntity? user;
  final RxBool isStartStation;
  final RxBool isFollow;
  final RxBool isMissingMusic;
  final RxBool isReport;
  final RxBool isBlockUser;

  const FixedIconsWidget({
    super.key,
    required this.userData,
    required this.user,
    required this.isStartStation,
    required this.isFollow,
    required this.isMissingMusic,
    required this.isReport,
    required this.isBlockUser,
  });

  Future<bool> checkIfBlocked(UserEntity? userEntity) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null || userEntity == null) {
      return false;
    }
    final currentUserId = user.uid;
    final targetUserId = userEntity.id;
    final blockedUsersRef = FirebaseFirestore.instance.collection('Users').doc(currentUserId).collection('BlockedUsers');
    final doc = await blockedUsersRef.doc(targetUserId).get();
    return doc.exists;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 3,
      left: 9,
      right: 6,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(color: context.isDarkMode ? AppColors.youngNight : AppColors.black, shape: BoxShape.circle),
              child: Padding(
                padding: const EdgeInsets.only(right: 2),
                child: Icon(Icons.arrow_back_ios_new, size: 20, color: context.isDarkMode ? AppColors.white : AppColors.black),
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(color: AppColors.youngNight, shape: BoxShape.circle),
              child: const Icon(Icons.cast, size: 22, color: AppColors.white),
            ),
          ),
          IconButton(
            onPressed: () {
              showShareProfileDialog(
                context,
                userData,
                user,
                isStartStation: isStartStation.value,
                isFollow: isFollow.value,
                isMissingMusic: isMissingMusic.value,
                isReport: isReport.value,
                isBlockUser: isBlockUser.value,
                checkIfBlocked: checkIfBlocked,
              );
            },
            icon: Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(color: AppColors.youngNight, shape: BoxShape.circle),
              child: const Icon(Icons.more_vert, size: 21, color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
