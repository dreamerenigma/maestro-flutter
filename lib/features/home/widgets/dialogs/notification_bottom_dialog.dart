import 'package:carbon_icons/carbon_icons.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';

Future<String?> showNotificationDialog(BuildContext context, String selectedOption) {
  return showModalBottomSheet(
    context: context,
    enableDrag: true,
    showDragHandle: false,
    isScrollControlled: true,
    backgroundColor: context.isDarkMode ? AppColors.backgroundColor : AppColors.lightBackground,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 5,
                  width: 40,
                  decoration: BoxDecoration(
                    color: context.isDarkMode ? AppColors.white : AppColors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.only(top: 10, bottom: 6),
                ),
              ),
              _buildNotificationOption(
                context,
                'Show all notifications',
                icon: Icons.notifications_none_outlined,
                isSelected: selectedOption == 'Show all notifications',
                onTap: () {
                  Navigator.pop(context, 'Show all notifications');
                },
              ),
              _buildNotificationOption(
                context,
                'Comments',
                svgIcon: SvgPicture.asset(
                  AppVectors.comment,
                  colorFilter: ColorFilter.mode(
                    selectedOption == 'Comments' ? AppColors.primary : (context.isDarkMode ? AppColors.white : AppColors.black),
                    BlendMode.srcIn,
                  ),
                  width: 22,
                  height: 22,
                ),
                isSelected: selectedOption == 'Comments',
                onTap: () {
                  Navigator.pop(context, 'Comments');
                },
              ),
              _buildNotificationOption(
                context,
                'Likes',
                icon: Icons.favorite_border_rounded,
                isSelected: selectedOption == 'Likes',
                onTap: () {
                  Navigator.pop(context, 'Likes');
                },
              ),
              _buildNotificationOption(
                context,
                'Followings',
                icon: FeatherIcons.user,
                isSelected: selectedOption == 'Followings',
                onTap: () {
                  Navigator.pop(context, 'Followings');
                }
              ),
              _buildNotificationOption(
                context,
                'Reposts',
                icon: CarbonIcons.repeat,
                isSelected: selectedOption == 'Reposts',
                rotationAngle: 1.57,
                onTap: () {
                  Navigator.pop(context, 'Reposts');
                }
              ),
            ],
          );
        }
      );
    },
  );
}

Widget _buildNotificationOption(
  BuildContext context,
  String text,
  {VoidCallback? onTap, IconData? icon, Widget? svgIcon, double rotationAngle = 0, bool isSelected = false}
) {
  Color iconColor = isSelected ? AppColors.primary : (context.isDarkMode ? AppColors.white : AppColors.black);
  Color textColor = isSelected ? AppColors.primary : (context.isDarkMode ? AppColors.white : AppColors.black);

  return InkWell(
    onTap: onTap,
    splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
    highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
      child: Row(
        children: [
          if (svgIcon != null)
            ColorFiltered(
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              child: Transform.rotate(
                angle: rotationAngle,
                child: svgIcon,
              ),
            )
          else if (icon != null)
            Transform.rotate(
              angle: rotationAngle,
              child: Icon(
                icon,
                color: iconColor,
                size: 26,
              ),
            ),
          if (icon != null || svgIcon != null) SizedBox(width: 16),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: AppSizes.fontSizeMd,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    ),
  );
}
