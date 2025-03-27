import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';

void showBlockReportProfileBottomDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    enableDrag: true,
    showDragHandle: false,
    isScrollControlled: true,
    backgroundColor: context.isDarkMode ? AppColors.backgroundColor : AppColors.lightBackground,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 5,
            width: 40,
            decoration: BoxDecoration(
              color: context.isDarkMode ? AppColors.white : AppColors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.only(top: 10, bottom: 6),
          ),
          _buildBottomSheetOption(
            icon: Icons.block_flipped,
            text: 'Block profile',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          _buildBottomSheetOption(
            svgIcon: SvgPicture.asset(
              AppVectors.flag,
              colorFilter: ColorFilter.mode(context.isDarkMode ? AppColors.white : AppColors.black, BlendMode.srcIn),
              width: 22,
              height: 22,
            ),
            text: 'Report profile',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 12)
        ],
      );
    },
  );
}

Widget _buildBottomSheetOption({
  required String text,
  required VoidCallback onTap,
  IconData? icon, Widget? svgIcon
}) {
  return InkWell(
    onTap: onTap,
    splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
    highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
    child: Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 16),
          Text(text, style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal, letterSpacing: -0.3)),
        ],
      ),
    ),
  );
}
