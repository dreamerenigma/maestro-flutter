import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maestro/features/search/screens/follow_screen.dart';
import 'package:maestro/routes/custom_page_route.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../api/apis.dart';
import '../../../../domain/entities/song/song_entity.dart';
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
  final SongEntity? selectedTrack;

  const UserMessageItem({
    super.key,
    required this.initialIndex,
    required this.userName,
    required this.message,
    required this.sent,
    required this.user,
    this.selectedTrack,
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

          return FutureBuilder<Map<String, dynamic>?>(
            future: userDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center();
              } else if (snapshot.hasError || !snapshot.hasData) {
                return Center(child: Text(S.of(context).errorLoadingProfile));
              } else {
              final userData = snapshot.data!;
              final isCurrentUser = FirebaseAuth.instance.currentUser?.uid == widget.user.id;
              final displayName = isDeleted ? S.of(context).deletedUser : isCurrentUser ? userData['name'] ?? '' : widget.user.name;

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      createPageRoute(
                        UserMessageScreen(initialIndex: 0, user: widget.user),
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
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Ink(
                              decoration: BoxDecoration(
                                color: AppColors.darkGrey,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.darkerGrey.withAlpha((0.2 * 255).toInt()), width: 1),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: widget.user.image.isNotEmpty
                                  ? CachedNetworkImage(
                                    imageUrl: widget.user.image,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Shimmer.fromColors(
                                      baseColor: AppColors.darkGrey,
                                      highlightColor: AppColors.steelGrey,
                                      child: Container(width: 45, height: 45, decoration: BoxDecoration(color: AppColors.white, shape: BoxShape.circle)),
                                    ),
                                    errorWidget: (context, url, error) => SvgPicture.asset(AppVectors.avatar, width: 22, height: 22),
                                  )
                                  : SvgPicture.asset(AppVectors.avatar, width: 50, height: 50),
                              ),
                            ),
                            Material(
                              color: AppColors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context, createPageRoute(FollowScreen(initialIndex: widget.initialIndex, user: widget.user)));
                                },
                                splashColor: AppColors.steelGrey.withAlpha((0.2 * 255).toInt()),
                                highlightColor: AppColors.steelGrey.withAlpha((0.2 * 255).toInt()),
                                borderRadius: BorderRadius.circular(40),
                                child: Container(width: 50, height: 50, decoration: BoxDecoration(borderRadius: BorderRadius.circular(40))),
                              ),
                            ),
                          ],
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
                                    child: Text(displayName, style: const TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.bold, height: 1)),
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
