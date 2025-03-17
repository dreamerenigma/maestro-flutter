import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final FocusNode? searchFocusNode;
  final bool hasFocus;
  final bool hasText;
  final Function() removeFocus;
  final Function(String) onChanged;
  final Function() clearSearch;

  const SearchBar({
    required this.searchController,
    required this.searchFocusNode,
    required this.hasFocus,
    required this.hasText,
    required this.removeFocus,
    required this.onChanged,
    required this.clearSearch,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 4, top: 40, bottom: 8),
      child: SizedBox(
        height: 40,
        child: TextSelectionTheme(
          data: TextSelectionThemeData(
            cursorColor: AppColors.primary,
            selectionColor: AppColors.primary.withAlpha((0.3 * 255).toInt()),
            selectionHandleColor: AppColors.primary,
          ),
          child: TextField(
            textInputAction: hasText ? TextInputAction.done : TextInputAction.search,
            controller: searchController,
            focusNode: searchFocusNode,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: S.of(context).search,
              hintStyle: TextStyle(color: context.isDarkMode ? AppColors.darkerGrey : AppColors.darkerGrey, fontSize: AppSizes.fontSizeLg),
              prefixIcon: IconButton(
                icon: Icon(
                  hasFocus ? Icons.arrow_back : EvaIcons.search,
                  color: context.isDarkMode ? AppColors.white : AppColors.darkGrey,
                ),
                onPressed: () {
                  if (hasFocus) {
                    searchController.clear();
                    onChanged('');
                    removeFocus();
                  } else {
                    FocusScope.of(context).requestFocus(searchFocusNode);
                  }
                },
              ),
              suffixIcon: hasText ? IconButton(icon: const Icon(IonIcons.close_circle, color: AppColors.white), onPressed: clearSearch) : null,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
              filled: true,
              fillColor: context.isDarkMode ? AppColors.darkGrey : AppColors.lightGrey,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            ),
            style: TextStyle(fontSize: AppSizes.fontSizeLg, fontWeight: FontWeight.w400),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
