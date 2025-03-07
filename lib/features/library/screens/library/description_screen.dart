import 'package:flutter/material.dart';
import 'package:maestro/common/widgets/app_bar/app_bar.dart';

import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

class DescriptionScreen extends StatefulWidget {
  final Function(String) onSaveDescription;

  const DescriptionScreen({super.key, required this.onSaveDescription});

  @override
  State<DescriptionScreen> createState() => DescriptionScreenState();
}

class DescriptionScreenState extends State<DescriptionScreen> {
  final TextEditingController _controller = TextEditingController();
  final int _maxLength = 4000;

  void _saveDescription() {
    widget.onSaveDescription(_controller.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: const Text('Edit description', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
        centerTitle: false,
        onSavePressed: _saveDescription,
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
            bottom: 16,
            right: 16,
            child: Text('${_maxLength - _controller.text.length}', style: const TextStyle(color: AppColors.grey)),
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
              hintText: 'Describe your track',
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
