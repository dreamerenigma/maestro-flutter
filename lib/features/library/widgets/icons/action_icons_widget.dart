import 'dart:developer';
import 'package:evil_icons_flutter/evil_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:maestro/features/chats/screens/user_message_screen.dart';
import 'package:typicons_flutter/typicons_flutter.dart';
import '../../../../domain/entities/user/user_entity.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../search/controllers/user_params_controller.dart';
import '../../../search/widgets/buttons/follow_button.dart';
import '../../../search/widgets/dialogs/notifications_bottom_dialog.dart';
import '../../screens/edit_profile_screen.dart';

class ActionIconsWidget extends StatefulWidget {
  final bool isShuffleActive;
  final Function() toggleShuffle;
  final int initialIndex;
  final bool showFollowButton;
  final RxBool isFollowing;
  final UserEntity? user;

  const ActionIconsWidget({
    super.key,
    required this.isShuffleActive,
    required this.toggleShuffle,
    required this.initialIndex,
    this.showFollowButton = false,
    required this.isFollowing,
    this.user,
  });

  @override
  State<ActionIconsWidget> createState() => _ActionIconsWidgetState();
}

class _ActionIconsWidgetState extends State<ActionIconsWidget> {
  late final int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final userParamsController = Get.find<UserParamsController>();
    final userParams = userParamsController.userParamsValue;

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 16),
      child: Row(
        children: [
          if (widget.showFollowButton)
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: FollowButton(initialIndex: widget.initialIndex, isFollowing: widget.isFollowing, userParams: userParams),
            ),
          if (!widget.showFollowButton)
          IconButton(
            icon: const Icon(Typicons.pencil, size: AppSizes.iconLg),
            onPressed: () {
              Navigator.push(context, createPageRoute(EditProfileScreen(initialIndex: widget.initialIndex)));
            },
          ),
          Obx(() {
            log('isFollowing value: ${widget.isFollowing.value}');
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
                        colorFilter: ColorFilter.mode(
                          context.isDarkMode ? AppColors.white : AppColors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
              )
              : const SizedBox();
          }),
          if (widget.showFollowButton)
          SizedBox(width: 4),
          IconButton(
            icon: const Icon(EvilIcons.envelope, size: AppSizes.iconXl),
            onPressed: () {
              Navigator.push(context, createPageRoute(UserMessageScreen(initialIndex: widget.initialIndex, selectedIndex: selectedIndex, user: widget.user)));
            },
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              Bootstrap.shuffle,
              color: widget.isShuffleActive ? AppColors.primary : AppColors.grey,
              size: AppSizes.iconMd,
            ),
            onPressed: widget.toggleShuffle,
          ),
          const SizedBox(width: 5),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white,
            ),
            child: IconButton(
              icon: Icon(
                Icons.play_arrow_rounded,
                color: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
                size: 32,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
