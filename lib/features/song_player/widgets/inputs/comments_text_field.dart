import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:maestro/utils/constants/app_colors.dart';
import 'package:maestro/utils/constants/app_sizes.dart';

class CommentsTextField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback clearText;
  final bool hasText;
  final Function() onSendPressed;

  const CommentsTextField({
    super.key,
    required this.controller,
    required this.clearText,
    required this.hasText,
    required this.onSendPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: 45,
          child: Row(
            children: [
              Expanded(
                child: TextSelectionTheme(
                  data: TextSelectionThemeData(
                    cursorColor: AppColors.primary,
                    selectionColor: AppColors.primary.withAlpha((0.3 * 255).toInt()),
                    selectionHandleColor: AppColors.primary,
                  ),
                  child: TextField(
                    controller: controller,
                    cursorColor: AppColors.primary,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.send,
                    onChanged: (text) {},
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).brightness == Brightness.dark ? AppColors.darkGrey : AppColors.grey.withAlpha((0.2 * 255).toInt()),
                      hintText: 'Comment at',
                      hintStyle: TextStyle(fontSize: AppSizes.fontSizeMd, color: context.isDarkMode ? AppColors.darkerGrey : AppColors.darkerGrey),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 8),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('0:00', style: TextStyle(color: context.isDarkMode ? AppColors.lightGrey : AppColors.darkGrey, fontSize: AppSizes.fontSizeSm)),
                          SizedBox(width: 2),
                          if (hasText)
                            IconButton(
                              onPressed: clearText,
                              icon: Icon(Ionicons.close_circle, size: 26, color: context.isDarkMode ? AppColors.lightGrey : AppColors.darkGrey),
                            ),
                        ],
                      ),
                    ),
                    style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              if (hasText)
                Container(
                  margin: const EdgeInsets.only(left: 8.0),
                  child: CircleAvatar(
                    backgroundColor: context.isDarkMode ? AppColors.white : AppColors.black,
                    radius: 24,
                    child: IconButton(
                      icon: Icon(CarbonIcons.send_alt, color: context.isDarkMode ? AppColors.black : AppColors.white, size: 30),
                      onPressed: onSendPressed,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
