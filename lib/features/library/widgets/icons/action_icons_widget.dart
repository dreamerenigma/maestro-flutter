import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:typicons_flutter/typicons_flutter.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../screens/edit_profile_screen.dart';

class ActionIconsWidget extends StatelessWidget {
  final bool isShuffleActive;
  final Function() toggleShuffle;
  final int initialIndex;

  const ActionIconsWidget({
    super.key,
    required this.isShuffleActive,
    required this.toggleShuffle,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Typicons.pencil, size: AppSizes.iconLg),
            onPressed: () {
              Navigator.push(context, createPageRoute(EditProfileScreen(initialIndex: initialIndex)));
            },
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              Bootstrap.shuffle,
              color: isShuffleActive ? AppColors.primary : AppColors.grey,
              size: AppSizes.iconMd,
            ),
            onPressed: toggleShuffle,
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
