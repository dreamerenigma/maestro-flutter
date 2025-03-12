import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maestro/features/library/controllers/playlist_image_controller.dart';
import 'package:maestro/features/library/screens/library/playlists/tags_playlist_screen.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import '../../../../common/widgets/input_fields/custom_text_field.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../bloc/playlist/playlist_cubit.dart';
import '../../bloc/playlist/playlist_state.dart';
import '../../screens/library/description_screen.dart';
import '../dialogs/playlist_image_bottom_dialog.dart';
import '../switches.dart';

class DetailsTab extends StatefulWidget {
  final Map<String, dynamic> playlist;
  final Function(String) onTitleChanged;
  final Function(String) onDescriptionChanged;
  final Function(List<String>) onTagsChanged;
  final Function(String) onImageUrlChanged;

  const DetailsTab({
    super.key,
    required this.playlist,
    required this.onTitleChanged,
    required this.onDescriptionChanged,
    required this.onTagsChanged,
    required this.onImageUrlChanged,
  });

  @override
  State<DetailsTab> createState() => _DetailsTabState();
}

class _DetailsTabState extends State<DetailsTab> {
  bool isPublic = false;
  String? _playlistImageUrl;
  String description = 'Describe your playlist';
  List<String> tags = [];
  final GetStorage _storageBox = GetStorage();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final TextEditingController _playlistTitleController = TextEditingController();
  final PlaylistImageController playlistImageController = Get.put(PlaylistImageController());
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _playlistTitleController.addListener(_updateDisplayNameCount);
    _playlistTitleController.text = widget.playlist['title'] ?? 'Untitled Playlist';
    _playlistImageUrl = widget.playlist['coverImage'];
    _loadPlaylist();
  }

  @override
  void dispose() {
    _playlistTitleController.dispose();
    super.dispose();
  }

  void _updateDisplayNameCount() {
    setState(() {});
  }

  Future<void> _navigateToDescriptionPage() async {
    await Navigator.push(
      context,
      createPageRoute(
        DescriptionScreen(
          onSaveDescription: (String value) {
            setState(() {
              _descriptionController.text = value;
            });
            widget.onDescriptionChanged(value);
          },
          hintText: description,
          controller: _descriptionController,
        ),
      ),
    );
  }

  void _navigateToTagsPage() async {
    final updatedTags = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TagsPlaylistScreen(
          onSaveTags: (List<String> tags) {
            setState(() {
              this.tags = tags;
            });
            widget.onTagsChanged(tags);
          },
        ),
      ),
    );
    if (updatedTags != null) {
      setState(() {
        tags = updatedTags;
      });
    }
  }

  Future<void> _loadPlaylist() async {
    final playlistState = context.read<PlaylistCubit>().state;
    if (playlistState is PlaylistLoaded) {
      String playlistId = playlistState.playlist.playlistId;

      try {
        final playlistSnapshot = await FirebaseFirestore.instance.collection('Playlists').doc(playlistId).get();

        if (playlistSnapshot.exists) {
          Map<String, dynamic> playlistData = playlistSnapshot.data() as Map<String, dynamic>;

          setState(() {
            _playlistTitleController.text = playlistData['title'] ?? 'Untitled Playlist';
            _descriptionController.text = playlistData['description'] ?? 'Describe your playlist';
            tags = playlistData['tags'] ?? 'No tags';
            isPublic = playlistData['isPublic'] ?? true;
          });

          log('Playlist loaded: description=$description, tags=$tags, isPublic=$isPublic');
        } else {
          log('Playlist not found');
        }
      } catch (e) {
        log('Error loading playlist data: $e');
      }
    }
  }

  Future<void> _takePhotoProfile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _playlistImageUrl = pickedFile.path;
      });
    }
  }

  Future<void> _pickImagePlaylist() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final File file = File(pickedFile.path);

      try {
        final Reference storageRef = _firebaseStorage.ref().child('playlist_cover/$fileName');
        await storageRef.putFile(file);

        final String downloadURL = await storageRef.getDownloadURL();

        playlistImageController.setPlaylistImage(downloadURL);

        setState(() {
          _playlistImageUrl = downloadURL;
        });
      } catch (e) {
        log('Error uploading image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('Please sign in to view content'));
    }

    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildAvatar(context),
            const SizedBox(height: 20),
            CustomTextField(label: 'Playlist title', controller:  _playlistTitleController, maxLength: 80, currentLength: _playlistTitleController.text.length),
            _buildTextFieldOption(
              labelText: 'Description',
              icon: Icons.arrow_forward_ios_rounded,
              onTap: _navigateToDescriptionPage,
              descriptionText: _descriptionController.text.isNotEmpty ? _descriptionController.text : '',
            ),
            _buildTextFieldOption(
              labelText: 'Tags',
              icon: Icons.arrow_forward_ios_rounded,
              onTap: _navigateToTagsPage,
              tagsText: tags.isNotEmpty ? tags.map((tag) => '#$tag').join(' ') : '',
            ),
            _buildSectionOption(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: GestureDetector(
        onTap: () {
          showPlaylistImageBottomDialog(context, _pickImagePlaylist, _takePhotoProfile);
        },
        child: Container(
          padding: const EdgeInsets.all(4),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.darkGrey,
                  shape: BoxShape.rectangle,
                  border: Border.all(color: AppColors.darkGrey, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    color: context.isDarkMode ? AppColors.youngNight : AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _playlistImageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          _playlistImageUrl!,
                          width: 170,
                          height: 170,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.camera_alt_outlined, size: 30),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white.withAlpha((0.3 * 255).toInt()),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.camera_alt_outlined, size: 30, color: AppColors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldOption({
    required String labelText,
    required IconData icon,
    required Function()? onTap,
    String tagsText = '',
    String descriptionText = '',
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onTap,
            splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
            highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
            child: Padding(
              padding: const EdgeInsets.only(left: 28, right: 20, top: 22, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(labelText, style: TextStyle(fontSize: AppSizes.fontSizeMd, color: AppColors.grey, height: 0.1)),
                      const SizedBox(height: 10),
                      if (tagsText.isNotEmpty)
                        Text(
                          tagsText,
                          style: TextStyle(fontSize: AppSizes.fontSizeMd, color: AppColors.lightGrey, fontWeight: FontWeight.w400),
                        ),
                      if (descriptionText.isNotEmpty)
                      Text(
                        descriptionText,
                        style: TextStyle(fontSize: AppSizes.fontSizeMd, color: AppColors.lightGrey, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  Icon(icon, size: 22, color: AppColors.lightGrey),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(color: AppColors.darkGrey, height: 0, thickness: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionOption(BuildContext context) {
    return InkWell(
      onTap: () {},
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      child: Container(
        padding: const EdgeInsets.only(left: 6, right: 6, top: 20, bottom: 10),
        child: InkWell(
          onTap: () {
            setState(() {
              isPublic = !isPublic;
            });
            _storageBox.write('isPublic', isPublic);
          },
          splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
          highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Make public', style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.bold)),
                CustomSwitch(
                  value: isPublic,
                  onChanged: (value) {
                    setState(() {
                      isPublic = value;
                    });
                    _storageBox.write('isPublic', isPublic);
                  },
                  activeColor: AppColors.primary,
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}
