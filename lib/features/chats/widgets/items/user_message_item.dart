import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maestro/routes/custom_page_route.dart';
import '../../../../api/apis.dart';
import '../../../../domain/entities/user/user_entity.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../screens/user_message_screen.dart';

class UserMessageItem extends StatefulWidget {
  final int initialIndex;
  final String userName;
  final String message;
  final String sent;
  final UserEntity user;

  const UserMessageItem({
    super.key,
    required this.initialIndex,
    required this.userName,
    required this.message,
    required this.sent,
    required this.user,
  });

  @override
  State<UserMessageItem> createState() => _UserMessageItemState();
}

class _UserMessageItemState extends State<UserMessageItem> {
  late Future<Map<String, dynamic>?> userDataFuture;
  late Future<bool> isDeletedUserFuture;
  late final int selectedIndex;
  late Stream<List<Map<String, dynamic>>> messageStream;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    userDataFuture = APIs.fetchUserData();
    isDeletedUserFuture = checkIfUserDeleted();
  }

  Future<bool> checkIfUserDeleted() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      log('No user logged in');
      throw Exception(S.of(context).noUserLoggedIn);
    }

    var userDoc = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
    if (!userDoc.exists) {
      log('User does not exist in Firestore');
    }
    return !userDoc.exists;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isDeletedUserFuture,
      builder: (context, isDeletedSnapshot) {
        if (isDeletedSnapshot.connectionState == ConnectionState.waiting) {
          return const Center();
        } else if (isDeletedSnapshot.hasError || isDeletedSnapshot.data == null) {
          return Center(child: Text(S.of(context).errorLoadingProfile));
        } else {
          final isDeleted = isDeletedSnapshot.data ?? false;
          final displayName = isDeleted ? S.of(context).deletedUser : widget.userName;

          return FutureBuilder<Map<String, dynamic>?>(
            future: userDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center();
              } else if (snapshot.hasError || !snapshot.hasData) {
                return Center(child: Text(S.of(context).errorLoadingProfile));
              } else {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      createPageRoute(
                        UserMessageScreen(initialIndex: widget.initialIndex, selectedIndex: selectedIndex, user: widget.user),
                      ),
                    );
                  },
                  splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                  highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()), width: 1),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: widget.user.image.isNotEmpty
                              ? Image.network(widget.user.image, width: 50, height: 50, fit: BoxFit.cover)
                              : SvgPicture.asset(AppVectors.avatar, width: 50, height: 50),
                          ),
                        ),
                        const SizedBox(width: 20.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      displayName,
                                      style: const TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.bold, height: 1),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.message,
                                      style: const TextStyle(fontSize: AppSizes.fontSizeSm, color: AppColors.grey),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text('·', style: TextStyle(fontSize: AppSizes.fontSizeMg, color: AppColors.grey, fontWeight: FontWeight.bold, height: 1)),
                                      SizedBox(width: 4),
                                      Text(widget.sent, style: const TextStyle(fontSize: AppSizes.fontSizeLm, color: AppColors.grey, height: 1)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
          );
        }
      },
    );
  }
}
