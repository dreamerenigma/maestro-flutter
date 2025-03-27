import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

class NewMessageTextField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? toggleSearch;
  final Function(String) onChanged;
  final Function()? onClearText;

  const NewMessageTextField({
    super.key,
    required this.controller,
    required this.toggleSearch,
    required this.onChanged,
    this.onClearText,
  });

  @override
  State<NewMessageTextField> createState() => _NewMessageTextFieldState();
}

class _NewMessageTextFieldState extends State<NewMessageTextField> {
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextSelectionTheme(
            data: TextSelectionThemeData(
              cursorColor: AppColors.primary,
              selectionColor: AppColors.primary.withAlpha((0.3 * 255).toInt()),
              selectionHandleColor: AppColors.primary,
            ),
            child: SizedBox(
              height: 50,
              child: TextFormField(
                controller: widget.controller,
                onChanged: widget.onChanged,
                decoration: InputDecoration(
                  counterText: '',
                  fillColor: AppColors.darkGrey,
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  prefixIcon: IconButton(
                    splashColor: context.isDarkMode ? AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : AppColors.grey.withAlpha((0.4 * 255).toInt()),
                    highlightColor: context.isDarkMode ? AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : AppColors.grey.withAlpha((0.4 * 255).toInt()),
                    icon: Icon(EvaIcons.search, color: Theme.of(context).brightness == Brightness.dark ? AppColors.white : AppColors.black),
                    onPressed: widget.toggleSearch,
                  ),
                  suffixIcon: _hasText
                    ? IconButton(
                        onPressed: widget.onClearText,
                        icon: Icon(Ionicons.close_circle, size: 26, color: context.isDarkMode ? AppColors.lightGrey : AppColors.darkGrey),
                      )
                    : null,
                ),
                style: TextStyle(fontSize: AppSizes.fontSizeLg, fontWeight: FontWeight.w400, letterSpacing: -0.5),
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
