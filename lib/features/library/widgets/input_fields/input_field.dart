import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jam_icons/jam_icons.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

class InputField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final VoidCallback? onIconPressed;
  final IconData? icon;
  final bool showIcon;
  final FocusNode? focusNode;
  final Function(String)? onSubmitted;

  const InputField({
    super.key,
    this.controller,
    this.hintText,
    this.onIconPressed,
    this.icon = JamIcons.settingsAlt,
    this.showIcon = true,
    this.focusNode,
    this.onSubmitted,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  void _clearText() {
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 40,
            child: TextSelectionTheme(
              data: TextSelectionThemeData(
                cursorColor: AppColors.primary,
                selectionColor: AppColors.primary.withAlpha((0.3 * 255).toInt()),
                selectionHandleColor: AppColors.primary,
              ),
              child: TextField(
                controller: _controller,
                focusNode: widget.focusNode,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.search,
                onSubmitted: widget.onSubmitted,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    fontSize: AppSizes.fontSizeMd,
                    fontWeight: FontWeight.normal,
                    color: context.isDarkMode ? AppColors.lightGrey : AppColors.darkGrey,
                  ),
                  prefixIcon: Icon(EvaIcons.search, color: context.isDarkMode ? AppColors.lightGrey : AppColors.darkGrey),
                  suffixIcon: _controller.text.isNotEmpty ?
                    IconButton(
                      onPressed: _clearText,
                      icon: Icon(Ionicons.close_circle, size: 26, color: context.isDarkMode ? AppColors.lightGrey : AppColors.darkGrey),
                    )
                  : null,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                  filled: true,
                  fillColor: context.isDarkMode ? AppColors.darkGrey : AppColors.lightGrey,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                ),
                style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ),
        if (widget.showIcon)
          SizedBox(width: 15),
        if (widget.showIcon)
          IconButton(
            onPressed: widget.onIconPressed,
            icon: Icon(widget.icon, size: 26, color: AppColors.grey),
          ),
      ],
    );
  }
}
