import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:maestro/common/widgets/app_bar/app_bar.dart';
import 'package:maestro/features/library/screens/select_country.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import 'package:maestro/utils/constants/app_sizes.dart';
import 'package:maestro/utils/constants/app_colors.dart';
import '../../../routes/custom_page_route.dart';
import '../controllers/background_controller.dart';
import '../controllers/profile_image_controller.dart';
import '../widgets/dialogs/are_your_sure_dialog.dart';
import '../widgets/dialogs/profile_image_bottom_dialog.dart';
import 'library/bio_info_screen.dart';
import 'library/your_links_screen.dart';

class EditProfileScreen extends StatefulWidget {
  final int initialIndex;

  const EditProfileScreen({super.key, required this.initialIndex});

  @override
  State<EditProfileScreen> createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  late List<Map<String, String>> links;
  late final int selectedIndex;
  String? _imageUrl;
  String? _imageUrlBg;
  String? country;
  String? flag;
  String? bio;
  final GetStorage _storageBox = GetStorage();
  final BackgroundController backgroundController = Get.find();
  final ProfileImageController profileImageController = Get.find();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadImageUrls();
    _loadProfileData();
    _displayNameController.addListener(_updateDisplayNameCount);
    _cityController.addListener(_updateCityCount);
    selectedIndex = widget.initialIndex;
    links = [];
  }

  void _updateDisplayNameCount() {
    setState(() {});
  }

  void _updateCityCount() {
    setState(() {});
  }

  Future<void> _loadImageUrls() async {
    setState(() {
      _imageUrl = _storageBox.read<String>('image');
      _imageUrlBg = _storageBox.read<String>('backgroundImage');
    });
  }

  Future<void> _loadProfileData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      _clearImageState();

      final userDoc = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();

      if (userDoc.exists) {
        final data = userDoc.data();
        setState(() {
          _displayNameController.text = data?['name'] ?? '';
          _cityController.text = data?['city'] ?? '';
          country = data?['country'];
          flag = data?['flag'];
          bio = data?['bio'];
          _imageUrl = data?['image'];
          _imageUrlBg = data?['backgroundImage'];
          if (data?['links'] != null) {
            links = List<Map<String, String>>.from(
              data?['links'].map((link) {
                return Map<String, String>.from(link as Map);
              })
            );
          } else {
            links = [];
          }
        });
      }
    } catch (e) {
      log('Error loading profile data: $e');
    }
  }

  Future<void> _pickImageBg() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final File file = File(pickedFile.path);

      try {
        final Reference storageRef = _firebaseStorage.ref().child('background/$fileName');
        await storageRef.putFile(file);

        final String downloadURL = await storageRef.getDownloadURL();

        backgroundController.setBackgroundImage(downloadURL);

        if (mounted) {
          setState(() {
            _imageUrlBg = downloadURL;
          });
        }
      } catch (e) {
        log('Error uploading image: $e');
      }
    }
  }

  Future<void> _takePhotoProfile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageUrl = pickedFile.path;
      });
    }
  }

  Future<void> _clearProfileImage() async {
    if (_imageUrl == null) {
      return;
    }

    try {
      log('Image URL: $_imageUrl');

      setState(() {
        _imageUrl = null;
      });

      log('Profile image deleted from widget.');

    } catch (e) {
      log('Error deleting image: $e');
    }
  }

  Future<void> _deleteOldProfileImage() async {
    if (_imageUrl == null) {
      return;
    }

    try {
      log('Deleting old profile image from Firebase Storage: $_imageUrl');
      final Uri url = Uri.parse(_imageUrl!);
      final String path = url.pathSegments.last;
      final String fullPath = 'profile_picture/$path';

      final Reference storageRef = FirebaseStorage.instance.ref().child(fullPath);
      await storageRef.delete();

      log('Profile image deleted from Firebase Storage');

      setState(() {
        _imageUrl = null;
      });

      await _storageBox.write('image', null);

      Get.snackbar('Success', 'Profile image deleted successfully');
    } catch (e) {
      if (e is FirebaseException && e.code == 'object-not-found') {
        log('Profile image not found, nothing to delete');
      } else {
        log('Error deleting old profile image: $e');
        Get.snackbar('Failed', 'Failed to delete profile image');
      }
    }
  }

  Future<void> _clearBackgroundImage() async {
    if (_imageUrlBg == null) {
      return;
    }

    try {
      log('Image URL: $_imageUrlBg');

      setState(() {
        _imageUrlBg = null;
      });

      log('Profile image deleted from widget.');

    } catch (e) {
      log('Error deleting image: $e');
    }
  }

  Future<void> _deleteOldBackgroundImage() async {
    if (_imageUrlBg == null) {
      return;
    }

    try {
      log('Deleting background image: $_imageUrlBg');
      final Uri url = Uri.parse(_imageUrlBg!);
      final String path = url.pathSegments.last;
      final String fullPath = 'background_image/$path';

      final Reference storageRef = FirebaseStorage.instance.ref().child(fullPath);
      await storageRef.delete();

      log('Background image deleted from Firebase Storage');

      setState(() {
        _imageUrlBg = null;
      });

      await _storageBox.write('backgroundImage', null);

      Get.snackbar('Success', 'Background image deleted successfully');
    } catch (e) {
      if (e is FirebaseException && e.code == 'object-not-found') {
        log('Background image not found, nothing to delete');
      } else {
        log('Error deleting background image: $e');
        Get.snackbar('Failed', 'Failed to delete background image');
      }
    }
  }

  Future<void> _pickImageProfile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final File file = File(pickedFile.path);

      try {
        final Reference storageRef = _firebaseStorage.ref().child('profile_picture/$fileName');
        await storageRef.putFile(file);

        final String downloadURL = await storageRef.getDownloadURL();

        profileImageController.setProfileImage(downloadURL);

        setState(() {
          _imageUrl = downloadURL;
        });
      } catch (e) {
        log('Error uploading image: $e');
      }
    }
  }

  Future<void> _saveProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      await FirebaseFirestore.instance.collection('Users').doc(user.uid).update({
        'name': _displayNameController.text,
        'city': _cityController.text,
        'country': country,
        'flag': flag,
        'bio': bio,
        'image': _imageUrl,
        'backgroundImage': _imageUrlBg,
        'links': links,
      });

      await _storageBox.write('image', _imageUrl);
      await _storageBox.write('backgroundImage', _imageUrlBg);

    } catch (e) {
      Get.snackbar('Failed', 'Failed to save profile: $e');
      log('Error saving profile: $e');
    }
  }

  Future<void> _saveAll() async {
    bool imagesUpdated = false;
    bool profileUpdated = false;

    try {
      if (_imageUrl != null || _imageUrlBg != null) {
        imagesUpdated = true;
      }

      if (_imageUrl != null && _imageUrl != _imageUrlBg) {
        await _deleteOldProfileImage();
      }

      if (_imageUrlBg != null && _imageUrlBg != _imageUrl) {
        await _deleteOldBackgroundImage();
      }

      await _saveProfile();
      profileUpdated = true;

      ScaffoldMessenger.of(context).clearSnackBars();

      if (imagesUpdated || profileUpdated) {
        Get.snackbar('Success', 'Profile saved successfully');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      Get.snackbar('Failed', 'Failed to save profile: $e');
    }
  }

  void _clearImageState() {
    setState(() {
      _imageUrl = null;
      _imageUrlBg = null;
    });
  }

  Future<void> _selectCountry() async {
    final selectedCountry = await Navigator.push<Map<String, String>>(
      context,
      createPageRoute(SelectCountryScreen()),
    );

    if (selectedCountry != null) {
      setState(() {
        country = selectedCountry['name'];
        flag = selectedCountry['flag'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: const Text('Edit profile', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
        centerTitle: false,
        saveButtonText: 'Save',
        onSavePressed: _saveAll,
        onBackPressed: () {
          showAreYouSureDialog(context);
        },
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildBackground(context),
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    _buildTextField('Display Name', _displayNameController, maxLength: 50, currentLength: _displayNameController.text.length),
                    _buildTextField('City', _cityController, maxLength: 35, currentLength: _cityController.text.length),
                    _buildCountrySelector(_selectCountry, flag: flag),
                    _buildBioInfo(() {
                      Navigator.push(context, createPageRoute(BioInfoScreen()));
                    }),
                    _buildYourLinks(() {
                      Navigator.push(
                        context,
                        createPageRoute(
                          YourLinksScreen(
                            initialIndex: selectedIndex,
                            links: links,
                            onLinksUpdated: (List<Map<String, String>> updatedLinks) {
                              setState(() {
                                links = updatedLinks;
                              });
                            },
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: InkWell(
        onTap: () {
          showProfileImageBottomDialog(
            context,
            _pickImageBg,
            _takePhotoProfile,
            _clearBackgroundImage,
            null,
            'Delete header image',
          );
        },
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            image: _imageUrlBg != null ? DecorationImage(image: NetworkImage(_imageUrlBg!), fit: BoxFit.cover) : null,
            color: context.isDarkMode ? AppColors.black : AppColors.lightBackground,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(color: AppColors.white.withAlpha((0.4 * 255).toInt())),
              _buildAvatar(context),
              _buildCameraIcon(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Positioned(
      left: 16,
      bottom: -75,
      child: GestureDetector(
        onTap: () {
          showProfileImageBottomDialog(
            context,
            _pickImageProfile,
            _takePhotoProfile,
            _clearBackgroundImage,
            _clearProfileImage,
            'Delete profile image',
          );
        },
        child: Container(
          padding: const EdgeInsets.all(4),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.darkGrey,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.darkGrey, width: 1),
                ),
                child: CircleAvatar(
                maxRadius: 65,
                backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.lightGrey,
                backgroundImage: _imageUrl != null
                  ? (_imageUrl!.startsWith('http') ? NetworkImage(_imageUrl!) : FileImage(File(_imageUrl!)))
                  : null,
                child: _imageUrl == null ? const Icon(Icons.camera_alt_outlined, size: 30) : null,
              ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(color: AppColors.white.withAlpha((0.3 * 255).toInt()), shape: BoxShape.circle),
                  child: const Icon(Icons.camera_alt_outlined, size: 30, color: AppColors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCameraIcon() {
    return Positioned(
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(6),
        child: IconButton(
          icon: const Icon(Icons.camera_alt_outlined, color: AppColors.black, size: 26),
          onPressed: () {
            showProfileImageBottomDialog(
              context,
              _pickImageBg,
              _takePhotoProfile,
              null,
              _clearBackgroundImage,
              'Delete header image',
            );
          },
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {required int maxLength, required int currentLength}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
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
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(fontSize: AppSizes.fontSizeLg, fontWeight: FontWeight.w400, letterSpacing: -0.5),
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

  Widget _buildCountrySelector(VoidCallback onTap, {required String? flag}) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 16, top: 16, bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Country', style: TextStyle(fontSize: AppSizes.fontSizeSm, color: AppColors.grey)),
                    Row(
                      children: [
                        if (flag != null) Padding(padding: const EdgeInsets.only(left: 2), child: SvgPicture.asset(flag, width: 18, height: 18)),
                        const SizedBox(width: 10),
                        Text(country ?? '', style: const TextStyle(fontSize: AppSizes.fontSizeMd)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildBioInfo(VoidCallback onTap) {
    final String truncatedBio = (bio?.length ?? 0) > 35 ? '${bio!.substring(0, 35)}...' : bio ?? '';

    return InkWell(
      onTap: onTap,
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 16, top: 14, bottom: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bio',
                      style: TextStyle(fontSize: AppSizes.fontSizeSm, color: AppColors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(truncatedBio, style: TextStyle(fontSize: AppSizes.fontSizeMd), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildYourLinks(VoidCallback onTap) {
    String linksText = links.isNotEmpty ? links.map((link) => link['webOrEmail'] ?? '').join('; ') : 'No links added';
    String truncatedLinks = linksText.length > 38 ? '${linksText.substring(0, 38)}...' : linksText;

    return InkWell(
      onTap: onTap,
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 16, top: 14, bottom: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your links',
                      style: TextStyle(fontSize: AppSizes.fontSizeSm, color: AppColors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      truncatedLinks,
                      style: TextStyle(fontSize: AppSizes.fontSizeMd),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 22),
          ],
        ),
      ),
    );
  }
}
