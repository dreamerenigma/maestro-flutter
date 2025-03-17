import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../utils/constants/app_colors.dart';
import '../../../../../../utils/constants/app_sizes.dart';

class TracksListRow extends StatelessWidget {
  final bool shouldShow;
  final List<dynamic> songs;
  final int initialIndex;
  final String title;
  final VoidCallback onPressedSeeAll;

  const TracksListRow({
    super.key,
    required this.shouldShow,
    required this.songs,
    required this.initialIndex,
    required this.title,
    required this.onPressedSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    if (!shouldShow) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 16, top: 20, bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.w800, letterSpacing: -1.3)),
          SizedBox(
            width: 65,
            height: 27,
            child: ElevatedButton(
              onPressed: onPressedSeeAll,
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
      ),
    );
  }
}
