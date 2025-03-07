import 'package:flutter/material.dart';
import 'package:maestro/common/widgets/app_bar/app_bar.dart';

import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

class CaptionScreen extends StatefulWidget {
  final Function(String) onSaveCaption;

  const CaptionScreen({super.key, required this.onSaveCaption});

  @override
  State<CaptionScreen> createState() => CaptionScreenState();
}

class CaptionScreenState extends State<CaptionScreen> {
  final TextEditingController _controller = TextEditingController();
  final int _maxLength = 140;

  void _saveCaption() {
    widget.onSaveCaption(_controller.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: const Text('Caption', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
        centerTitle: false,
        onSavePressed: _saveCaption,
        saveButtonText: 'Save',
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cast, size: 22, color: AppColors.grey),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Expanded(child: _buildTextField()),
              ],
            ),
          ),
          Positioned(
            bottom: 75,
            right: 16,
            child: Text('${_maxLength - _controller.text.length}', style: const TextStyle(color: AppColors.grey)),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: AppColors.darkGrey,
              child: Row(
                children: [
                  const Icon(Icons.info_rounded, color: AppColors.white, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Your track will be posted to your followers streams when you make it public.',
                      style: const TextStyle(color: AppColors.white, letterSpacing: -0.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextSelectionTheme(
          data: TextSelectionThemeData(
            cursorColor: AppColors.primary,
            selectionColor: AppColors.primary.withAlpha((0.3 * 255).toInt()),
            selectionHandleColor: AppColors.primary,
          ),
          child: TextFormField(
            controller: _controller,
            maxLength: _maxLength,
            maxLines: null,
            onChanged: (text) {
              setState(() {});
            },
            decoration: InputDecoration(
              hintText: 'Add a caption to your post (optional)',
              hintStyle: const TextStyle(color: AppColors.lightGrey, fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w200),
              counterText: '',
              border: InputBorder.none,
              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.transparent)),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.transparent)),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
            textCapitalization: TextCapitalization.sentences,
            style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}
