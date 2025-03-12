import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLength;
  final int currentLength;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.maxLength,
    required this.currentLength,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(label, style: TextStyle(fontSize: AppSizes.fontSizeSm, color: AppColors.grey, height: 0.1)),
          ),
          TextSelectionTheme(
            data: TextSelectionThemeData(
              cursorColor: AppColors.primary,
              selectionColor: AppColors.primary.withAlpha((0.3 * 255).toInt()),
              selectionHandleColor: AppColors.primary,
            ),
            child: TextFormField(
              controller: controller,
              maxLength: maxLength,
              decoration: InputDecoration(
                counterText: '',
                border: InputBorder.none,
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.darkGrey)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: context.isDarkMode ? AppColors.white : AppColors.black)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              style: TextStyle(fontSize: AppSizes.fontSizeLg, fontWeight: FontWeight.w400, letterSpacing: -0.5),
              textCapitalization: TextCapitalization.sentences,
              onChanged: (text) {},
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('$currentLength/$maxLength', style: const TextStyle(color: AppColors.grey, fontSize: 13, fontWeight: FontWeight.w100)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
