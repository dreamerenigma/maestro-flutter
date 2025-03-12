import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../utils/constants/app_colors.dart';
import '../../../../../../utils/constants/app_sizes.dart';
import '../../../../../routes/custom_page_route.dart';
import '../../../screens/profile/all_playlists_screen.dart';

class PlaylistListRow extends StatelessWidget {
  final bool shouldShow;
  final List<dynamic> playlists;
  final int initialIndex;

  const PlaylistListRow({
    super.key,
    required this.shouldShow,
    required this.playlists,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> playlists = [];

    if (!shouldShow) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 16, top: 20, bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Playlists', style: TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.w800, letterSpacing: -1.3)),
          SizedBox(
            width: 65,
            height: 27,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  createPageRoute(AllPlaylistsScreen(playlists: playlists, initialIndex: initialIndex)),
                );
              },
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
