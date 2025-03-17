import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

class MessageTextField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final Function(String)? onSend;
  final Function()? onAttach;

  const MessageTextField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onSend,
    this.onAttach,
  });

  @override
  MessageTextFieldState createState() => MessageTextFieldState();
}

class MessageTextFieldState extends State<MessageTextField> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _hasText = widget.controller.text.isNotEmpty;
    });
  }

  void _clearText() {
    widget.controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                    controller: widget.controller,
                    cursorColor: AppColors.primary,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: widget.onChanged,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).brightness == Brightness.dark ? AppColors.darkGrey : AppColors.grey.withAlpha((0.2 * 255).toInt()),
                      hintText: S.of(context).typeYourMessage,
                      hintStyle: TextStyle(fontSize: AppSizes.fontSizeMd, color: context.isDarkMode ? AppColors.darkerGrey : AppColors.darkerGrey),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                      prefixIcon: IconButton(
                        icon: Icon(
                          Icons.attach_file_outlined,
                          color: Theme.of(context).brightness == Brightness.dark ? AppColors.white : AppColors.black,
                        ),
                        onPressed: widget.onAttach,
                      ),
                      suffixIcon: _hasText
                        ? IconButton(
                            onPressed: _clearText,
                            icon: Icon(Ionicons.close_circle, size: 26, color: context.isDarkMode ? AppColors.lightGrey : AppColors.darkGrey),
                          )
                        : null,
                    ),
                    style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              if (_hasText)
              Container(
                margin: const EdgeInsets.only(left: 8.0),
                child: CircleAvatar(
                  backgroundColor: context.isDarkMode ? AppColors.white : AppColors.black,
                  radius: 24,
                  child: IconButton(
                    icon: Icon(CarbonIcons.send_alt, color: context.isDarkMode ? AppColors.black : AppColors.white, size: 30),
                    onPressed: () {
                      if (widget.onSend != null) {
                        widget.onSend!(widget.controller.text);
                      }
                    },
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

