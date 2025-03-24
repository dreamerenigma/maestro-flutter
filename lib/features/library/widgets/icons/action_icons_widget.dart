import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evil_icons_flutter/evil_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:maestro/features/chats/screens/user_message_screen.dart';
import 'package:mono_icons/mono_icons.dart';
import 'package:typicons_flutter/typicons_flutter.dart';
import '../../../../domain/entities/song/song_entity.dart';
import '../../../../domain/entities/user/user_entity.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../search/controllers/user_params_controller.dart';
import '../../../search/widgets/buttons/follow_button.dart';
import '../../../search/widgets/dialogs/notifications_bottom_dialog.dart';
import '../../../song_player/bloc/song_player_cubit.dart';
import '../../../song_player/bloc/song_player_state.dart';
import '../../screens/edit_profile_screen.dart';
import '../dialogs/clear_listening_history_dialog.dart';

class ActionIconsWidget extends StatefulWidget {
  final bool isShuffleActive;
  final Function() toggleShuffle;
  final int initialIndex;
  final bool showFollowButton;
  final bool showEditProfileButton;
  final bool showDeleteHistory;
  final RxBool isFollowing;
  final UserEntity? user;
  final SongEntity? song;

  const ActionIconsWidget({
    super.key,
    required this.isShuffleActive,
    required this.toggleShuffle,
    required this.initialIndex,
    this.showFollowButton = false,
    required this.isFollowing,
    this.user,
    this.song,
    this.showDeleteHistory = false,
    this.showEditProfileButton = true,
  });

  @override
  State<ActionIconsWidget> createState() => _ActionIconsWidgetState();
}

class _ActionIconsWidgetState extends State<ActionIconsWidget> {
  late final int selectedIndex;
  bool isBlocked = false;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    _checkIfBlocked();
  }

  void _checkIfBlocked() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    if (widget.user == null) {
      log('Error: user is null.');
      return;
    }

    // if (widget.user!.id == null || widget.user!.id.isEmpty) {
    //   log('Error: user id is null or empty.');
    //   return;
    // }

    final currentUserId = user.uid;
    final targetUserId = widget.user!.id;

    final blockedUsersRef = FirebaseFirestore.instance.collection('Users').doc(currentUserId).collection('BlockedUsers');
    final doc = await blockedUsersRef.doc(targetUserId).get();

    if (doc.exists) {
      setState(() {
        isBlocked = true;
      });
    } else {
      setState(() {
        isBlocked = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userParamsController = Get.find<UserParamsController>();
    final userParams = userParamsController.userParamsValue;

    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 16),
      child: Row(
        children: [
          if (widget.showDeleteHistory)
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: IconButton(
              icon: const Icon(MonoIcons.delete, size: AppSizes.iconLg),
              onPressed: () {
                showClearListeningHistoryDialog(context);
              },
            ),
          ),
          if (isBlocked)
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Icon(Icons.block_flipped, size: AppSizes.iconLg),
          ),
          if (widget.showFollowButton && !isBlocked)
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: FollowButton(initialIndex: widget.initialIndex, isFollowing: widget.isFollowing, userParams: userParams, userEntity: widget.user!),
            ),
          if (!isBlocked && widget.showEditProfileButton)
          IconButton(
            icon: const Icon(Typicons.pencil, size: AppSizes.iconLg),
            onPressed: () {
              Navigator.push(context, createPageRoute(EditProfileScreen(initialIndex: widget.initialIndex)));
            },
          ),
          if (!isBlocked)
          Obx(() {
            return widget.isFollowing.value
              ? Padding(
                padding: const EdgeInsets.only(left: 4),
                child: InkWell(
                  onTap: () {
                    showNotificationsDialog(context);
                  },
                  splashColor: context.isDarkMode ? AppColors.darkGrey.withAlpha((0.4 * 255).toInt()) : AppColors.grey.withAlpha((0.4 * 255).toInt()),
                  highlightColor: context.isDarkMode ? AppColors.darkGrey.withAlpha((0.4 * 255).toInt()) : AppColors.grey.withAlpha((0.4 * 255).toInt()),
                  borderRadius: BorderRadius.circular(AppSizes.cardRadiusXl),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SvgPicture.asset(
                      AppVectors.notificationCheck,
                      width: AppSizes.iconLg,
                      height: AppSizes.iconLg,
                      colorFilter: ColorFilter.mode(context.isDarkMode ? AppColors.white : AppColors.black, BlendMode.srcIn),
                    ),
                  ),
                ),
              )
              : const SizedBox();
          }),
          if (!isBlocked && widget.showFollowButton)
          SizedBox(width: 4),
          if (!isBlocked && widget.showFollowButton)
          IconButton(
            icon: const Icon(EvilIcons.envelope, size: AppSizes.iconXl),
            onPressed: () {
              Navigator.push(context, createPageRoute(UserMessageScreen(initialIndex: 0, user: widget.user)));
            },
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Bootstrap.shuffle, color: widget.isShuffleActive ? AppColors.primary : AppColors.grey, size: AppSizes.iconMd),
            onPressed: widget.toggleShuffle,
          ),
          const SizedBox(width: 5),
          BlocBuilder<SongPlayerCubit, SongPlayerState>(
            builder: (context, state) {
              final isPlaying = context.read<SongPlayerCubit>().audioPlayer.playing;

              return Container(
                decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white),
                child: IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                    color: context.isDarkMode ? AppColors.black : AppColors.white,
                    size: 32,
                  ),
                  onPressed: () {
                    context.read<SongPlayerCubit>().playOrPauseSong(widget.song);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
