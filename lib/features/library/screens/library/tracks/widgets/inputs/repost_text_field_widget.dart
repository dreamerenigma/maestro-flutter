import 'package:flutter/material.dart';
import '../../../../../../../utils/constants/app_colors.dart';
import '../../../../../../../utils/constants/app_sizes.dart';

class RepostTextFieldWidget extends StatefulWidget {
  final TextEditingController controller;

  const RepostTextFieldWidget({super.key, required this.controller});

  @override
  RepostTextFieldWidgetState createState() => RepostTextFieldWidgetState();
}

class RepostTextFieldWidgetState extends State<RepostTextFieldWidget> {
  int _charCount = 0;
  final int _maxLength = 140;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateCharCount);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateCharCount);
    widget.controller.dispose();
    super.dispose();
  }

  void _updateCharCount() {
    setState(() {
      _charCount = widget.controller.text.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextSelectionTheme(
            data: TextSelectionThemeData(
              cursorColor: AppColors.primary,
              selectionColor: AppColors.primary.withAlpha((0.3 * 255).toInt()),
              selectionHandleColor: AppColors.primary,
            ),
            child: TextField(
              controller: widget.controller,
              maxLines: 1,
              maxLength: _maxLength,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                floatingLabelStyle: TextStyle(color: AppColors.grey, fontSize: AppSizes.fontSizeLg, fontWeight: FontWeight.normal, letterSpacing: 0.3),
                labelText: 'Add a caption (optional)',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.grey)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.white)),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.white)),
                counterText: "",
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyle(fontSize: AppSizes.fontSizeLg, fontWeight: FontWeight.w400, letterSpacing: -0.5),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 12, top: 6, bottom: 8),
              child: Text('$_charCount/$_maxLength', style: TextStyle(fontSize: 13, color: AppColors.grey)),
            ),
          ),
        ],
      ),
    );
  }
}
