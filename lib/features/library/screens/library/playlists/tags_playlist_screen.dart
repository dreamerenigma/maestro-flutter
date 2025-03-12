import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../../common/widgets/app_bar/app_bar.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';

class TagsPlaylistScreen extends StatefulWidget {
  final Function(List<String>) onSaveTags;

  const TagsPlaylistScreen({super.key, required this.onSaveTags});

  @override
  State<TagsPlaylistScreen> createState() => _TagsPlaylistScreenState();
}

class _TagsPlaylistScreenState extends State<TagsPlaylistScreen> {
  final int _maxLength = 30;
  final TextEditingController _tagsController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    List<String> storedTags = (GetStorage().read('tags') ?? []).cast<String>();
    setState(() {
      _tags.addAll(storedTags);
    });
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _tagsController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _saveTags() {
    GetStorage().write('tags', _tags);
    widget.onSaveTags(_tags);
  }

  void _handleTextInput(String text) {
    setState(() {
    });
  }

  void _onSubmitted(String value) {
    List<String> newTags = value.split(RegExp(r'\s+')).where((tag) => tag.isNotEmpty).toList();

    setState(() {
      for (var tag in newTags) {
        if (!_tags.contains(tag)) {
          _tags.add(tag);
        }
      }
      log('Updated tags: $_tags');
      _tagsController.clear();
    });

    FocusScope.of(context).requestFocus(_focusNode);
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: Text('Tags', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
        saveButtonText: 'Save',
        onSavePressed: _saveTags,
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _buildTagsTextField(),
                if (_tags.isNotEmpty) _buildAppliedTagsText(),
                if (_tags.isNotEmpty) _buildTagsContainers(),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_tags.isNotEmpty)
                  Text('${_tags.length}/$_maxLength tags', style: const TextStyle(color: AppColors.grey)),
                if (_tags.isEmpty)
                  const Text('30 tags', style: TextStyle(color: AppColors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppliedTagsText() {
    return const Padding(
      padding: EdgeInsets.only(top: 20),
      child: Text('Applied tags', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.grey)),
    );
  }

  Widget _buildTagsContainers() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Wrap(
        spacing: 12.0,
        runSpacing: 20.0,
        children: _tags.map((tag) {
          return SizedBox(
            height: 40,
            child: GestureDetector(
              onTap: () {
                _removeTag(tag);
              },
              child: Chip(
                padding: EdgeInsets.zero,
                backgroundColor: AppColors.darkGrey,
                labelPadding: EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.tag_sharp, size: 18, color: context.isDarkMode ? AppColors.white : AppColors.black),
                    SizedBox(width: 4),
                    Text(tag, style: TextStyle(color: context.isDarkMode ? AppColors.white : AppColors.black, fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w400)),
                    SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        _removeTag(tag);
                      },
                      child: Icon(Icons.close, size: 18, color: context.isDarkMode ? AppColors.white : AppColors.black),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTagsTextField() {
    return TextSelectionTheme(
      data: TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionColor: AppColors.primary.withAlpha((0.3 * 255).toInt()),
        selectionHandleColor: AppColors.primary,
      ),
      child: TextField(
        controller: _tagsController,
        focusNode: _focusNode,
        maxLength: _maxLength,
        maxLines: null,
        textInputAction: TextInputAction.go,
        onChanged: _handleTextInput,
        decoration: InputDecoration(
          hintText: 'Tap Enter or Space after each tag',
          hintStyle: const TextStyle(color: AppColors.darkerGrey, fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w200),
          counterText: '',
          border: InputBorder.none,
          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.white)),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.white)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ),
        style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w400),
        onSubmitted: _onSubmitted,
      ),
    );
  }
}
