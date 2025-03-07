import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

class LikesListRow extends StatelessWidget {
  final bool shouldShow;
  final List<dynamic> songs;
  final int initialIndex;

  const LikesListRow({
    super.key,
    required this.shouldShow,
    required this.songs,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    if (!shouldShow) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Likes', style: TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.w800, letterSpacing: -1.3)),
        SizedBox(
          width: 65,
          height: 27,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: context.isDarkMode ? AppColors.darkGrey : AppColors.lightGrey,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              side: BorderSide.none,
            ).copyWith(
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.pressed)) {
                  return AppColors.darkerGrey;
                } else {
                  return AppColors.white;
                }
              }),
            ),
            child: const Text('See All', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        ),
      ],
    );
  }
}
