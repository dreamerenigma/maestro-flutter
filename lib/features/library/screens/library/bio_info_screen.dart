import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/app_bar/app_bar.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

class BioInfoScreen extends StatefulWidget {
  const BioInfoScreen({super.key});

  @override
  State<BioInfoScreen> createState() => _BioInfoScreenState();
}

class _BioInfoScreenState extends State<BioInfoScreen> {
  String? _bioInfo;
  final TextEditingController _bioController = TextEditingController();
  final int _maxLength = 4000;

  @override
  void initState() {
    super.initState();
    _bioController.addListener(_updateBioCount);
    _loadBio();
  }

  void _updateBioCount() {
    setState(() {});
  }

  Future<void> _loadBio() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      final userDoc = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
      if (userDoc.exists) {
        String bio = userDoc.data()?['bio'] ?? '';
        _bioController.text = bio;
      }
    } catch (e) {
      log('Error loading bio: $e');
      Get.snackbar('Error', 'Failed to load bio');
    }
  }

  Future<void> _saveBio() async {
    bool imagesUpdated = false;
    bool profileUpdated = false;

    try {
      if (_bioInfo != null) {
        imagesUpdated = true;
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      await FirebaseFirestore.instance.collection('Users').doc(user.uid).update({
        'bio': _bioController.text,
      });

      profileUpdated = true;

      log('Images updated: $imagesUpdated, Profile updated: $profileUpdated');

      ScaffoldMessenger.of(context).clearSnackBars();

      if (imagesUpdated || profileUpdated) {
        Get.snackbar('Success', 'Bio info saved successfully');
      }
    } catch (e) {
      log('Error saving profile data: $e');
      ScaffoldMessenger.of(context).clearSnackBars();
      Get.snackbar('Failed', 'Failed to save bio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: const Text('Bio', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
        centerTitle: false,
        saveButtonText: 'Save',
        onSavePressed: _saveBio,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildBioTextField('Bio', _bioController, maxLength: _maxLength, currentLength: _maxLength - _bioController.text.length),
            ],
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Text('${_maxLength - _bioController.text.length}', style: const TextStyle(color: AppColors.grey, fontSize: AppSizes.fontSizeSm)),
          ),
        ],
      ),
    );
  }

  Widget _buildBioTextField(String label, TextEditingController controller, {required int maxLength, required int currentLength}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
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
                controller: controller,
                maxLength: maxLength,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                cursorColor: AppColors.blue,
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(fontSize: 17, height: 1.3, letterSpacing: -0.5),
                decoration: InputDecoration(
                  counterText: '',
                  contentPadding: const EdgeInsets.all(16.0),
                  hintStyle: const TextStyle(fontSize: AppSizes.fontSizeMd),
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
