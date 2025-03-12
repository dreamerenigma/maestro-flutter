import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maestro/routes/custom_page_route.dart';
import '../../../common/widgets/buttons/basic_app_button.dart';
import '../../../data/services/image/image_service.dart';
import '../../../utils/constants/app_colors.dart';
import '../models/create_user_req.dart';
import '../../home/screens/home_screen.dart';

class CreateInfoScreen extends StatefulWidget {
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const CreateInfoScreen({
    super.key,
    required this.fullNameController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  CreateInfoScreenState createState() => CreateInfoScreenState();
}

class CreateInfoScreenState extends State<CreateInfoScreen> {
  String? _selectedGender;
  int? _selectedAge;
  File? _image;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<int> _ages = List<int>.generate(100, (index) => index + 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Additional Info'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(child: _profilePicture()),
                  const SizedBox(height: 20),
                  Center(child: _genderDropdown()),
                  const SizedBox(height: 20),
                  Center(child: _ageDropdown()),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: BasicAppButton(
              callback: () async {
                await _createAccount();
              },
              title: 'Create Account',
            ),
          ),
        ],
      ),
    );
  }

  Widget _profilePicture() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(40),
            image: _image != null ? DecorationImage(image: FileImage(_image!), fit: BoxFit.cover) : null,
          ),
        ),
        Positioned(
          bottom: -8,
          right: -8,
          child: GestureDetector(
            onTap: () {
              pickImage(context);
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              child: const Icon(Icons.camera_alt_outlined, color: AppColors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _genderDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Gender', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text('Select Gender'),
                value: _selectedGender,
                onChanged: (newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
                items: _genders.map((gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ageDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Age', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                isExpanded: true,
                hint: const Text('Select Age'),
                value: _selectedAge,
                onChanged: (newValue) {
                  setState(() {
                    _selectedAge = newValue;
                  });
                },
                items: _ages.map((age) {
                  return DropdownMenuItem(
                    value: age,
                    child: Text(age.toString()),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createAccount() async {
    try {
      final auth = FirebaseAuth.instance;
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: widget.emailController.text,
        password: widget.passwordController.text,
      );

      final String uid = userCredential.user?.uid ?? '';
      final imageUrl = await uploadImage();
      final time = DateTime.now().millisecondsSinceEpoch.toString();

      final createUserReq = CreateUserReq(
        id: uid,
        createdAt: time,
        name: widget.fullNameController.text,
        email: widget.emailController.text,
        password: widget.passwordController.text,
        image: imageUrl ?? '',
        gender: _selectedGender,
        age: _selectedAge,
      );

      final firestore = FirebaseFirestore.instance;
      await firestore.collection('Users').doc(uid).set(createUserReq.toJson());

      Navigator.pushAndRemoveUntil(context, createPageRoute(HomeScreen()), (route) => false);

    } catch (e) {
      final snackbar = SnackBar(
        content: Text(e.toString()),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }
}
