import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

final _picker = ImagePicker();
File? _image;

Future<void> pickImage(BuildContext context) async {
  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    _image = File(pickedFile.path);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Image selected: ${pickedFile.path}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

Future<String?> uploadImage() async {
  if (_image == null) return null;

  try {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child('profile_pictures/${DateTime.now().toIso8601String()}.png');
    final uploadTask = imageRef.putFile(_image!);

    final snapshot = await uploadTask.whenComplete(() {});
    final imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl;
  } catch (e) {
    Logger().e('Error uploading image: $e');
    return null;
  }
}