import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maestro/features/library/widgets/dialogs/are_your_sure_dialog.dart';
import 'package:mono_icons/mono_icons.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../../../common/widgets/app_bar/app_bar.dart';
import '../../../../../common/widgets/input_fields/custom_text_field.dart';
import '../../../../../data/services/song/song_firebase_service.dart';
import '../../../../../domain/entities/song/song_entity.dart';
import '../../../../../routes/custom_page_route.dart';
import '../../../../../service_locator.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../home/widgets/images/song_picture_widget.dart';
import '../../../../home/widgets/options/option_widget.dart';
import '../../../../home/widgets/privacy_setting_widget.dart';
import '../../../bloc/song/song_cubit.dart';
import '../../../bloc/song/song_state.dart';
import '../../../controllers/track_image_controller.dart';
import '../../../widgets/dialogs/delete_track_dialog.dart';
import '../../../widgets/dialogs/track_image_bottom_dialog.dart';
import '../caption_screen.dart';
import '../description_screen.dart';
import '../genre_screen.dart';

class EditTrackScreen extends StatefulWidget {
  final AssetEntity? selectedImage;

  const EditTrackScreen({super.key, this.selectedImage});

  @override
  State<EditTrackScreen> createState() => _EditTrackScreenState();
}

class _EditTrackScreenState extends State<EditTrackScreen> {
  final GetStorage _storageBox = GetStorage();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TrackImageController trackImageController = Get.put(TrackImageController());
  bool _isPublic = true;
  bool isHovering = false;
  AssetEntity? _selectedImage;
  String? selectedGenre;
  String? _trackImageUrl;
  String description = 'Describe your track';
  String caption = 'Add a caption to your post (optional)';

  @override
  void initState() {
    super.initState();
    _loadPrivacySetting();
    _loadSong();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final songState = context.read<SongCubit>().state;
    if (songState is SongLoaded && _trackImageUrl == null) {
      setState(() {
        _trackImageUrl = songState.song.cover;
      });
    }
  }

  Future<void> _loadSong() async {
    final songState = context.read<SongCubit>().state;
    if (songState is SongLoaded) {
      String songId = songState.song.songId;

      try {
        final songSnapshot = await FirebaseFirestore.instance.collection('Songs').doc(songId).get();

        if (songSnapshot.exists) {
          Map<String, dynamic> songData = songSnapshot.data() as Map<String, dynamic>;

          setState(() {
            selectedGenre = songData['genre'] ?? 'Unknown Genre';
            description = songData['description'] ?? 'No description';
            caption = songData['caption'] ?? 'No caption';
            _isPublic = songData['isPublic'] ?? true;
          });
        } else {
          log('Song not found');
        }
      } catch (e) {
        log('Error loading song data: $e');
      }
    }
  }

  Future<void> _pickImageTrack() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final File file = File(pickedFile.path);

      try {
        final Reference storageRef = _firebaseStorage.ref().child('song_cover/$fileName');
        await storageRef.putFile(file);

        final String downloadURL = await storageRef.getDownloadURL();
        log('Image uploaded successfully! downloadURL: $downloadURL');

        trackImageController.setPlaylistImage(downloadURL);

        setState(() {
          _trackImageUrl = downloadURL;
          _selectedImage = null;
        });
      } catch (e) {
        log('Error uploading image: $e');
      }
    } else {
      log('No image selected!');
    }
  }

  Future<void> _takePhotoProfile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _trackImageUrl = pickedFile.path;
      });
    }
  }

  void _updateTitleController(String title) {
    _titleController.text = title;
  }

  void _handleImageTap() {
    showTrackImageBottomDialog(context, _pickImageTrack, _takePhotoProfile);
  }

  void _onLongPress() {
    setState(() => isHovering = true);
  }

  void _onLongPressEnd() {
    setState(() => isHovering = false);
  }

  Future<void> _selectGenre() async {
    final result = await Navigator.push(context, createPageRoute(PickGenreScreen()));

    if (result != null && result is String) {
      setState(() {
        selectedGenre = result;
      });
    }
  }

  Future<void> _navigateToDescriptionPage() async {
    await Navigator.push(
      context,
      createPageRoute(
        DescriptionScreen(
          onSaveDescription: (String value) {
            setState(() {
              description = value;
            });
          },
          hintText: description,
          controller: _descriptionController,
        ),
      ),
    );
  }

  Future<void> _navigateToCaptionPage() async {
    await Navigator.push(
      context,
      createPageRoute(
        CaptionScreen(
          onSaveCaption: (String value) {
            setState(() {
              caption = value;
            });
          },
        ),
      ),
    );
  }

  Future<void> _onSavePressed() async {
    final songState = context.read<SongCubit>().state;
    if (songState is SongLoaded) {

      final song = songState.song;
      final updatedCover = _trackImageUrl ?? song.cover;
      final updatedTitle = _titleController.text;
      final updatedGenre = selectedGenre ?? song.genre;
      final updatedDescription = description;
      final updatedCaption = caption;
      final updatedIsPublic = _isPublic;

      try {
        final result = await sl<SongFirebaseService>().updateSong(
          song.songId,
          updatedCover,
          updatedTitle,
          updatedGenre,
          updatedDescription,
          updatedCaption,
          updatedIsPublic,
        );

        result.fold(
          (error) {
            Get.snackbar('Failed', 'Failed to update song: $error');
          },
          (successMessage) {
            Get.snackbar('Success', 'Update Track Complete');
            Navigator.of(context).pop();
          },
        );
      } catch (e) {
        log('Error while updating song: $e');
        Get.snackbar('Error', 'An error occurred while saving the song');
      }
    }
  }

  void _loadPrivacySetting() {
    _isPublic = _storageBox.read('isPublic') ?? true;
  }

  void _savePrivacySetting() {
    _storageBox.write('isPublic', _isPublic);
  }

  void _togglePrivacySetting(bool value) {
    setState(() {
      _isPublic = value;
      _savePrivacySetting();
    });
  }

  void onTrackDeleted() {
    Navigator.of(context).pop();
    Get.snackbar('Success', 'Track deleted successfully');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        saveButtonText: 'Save',
        onSavePressed: _onSavePressed,
        onBackPressed: () {
          showAreYouSureDialog(context);
        },
        centerTitle: false,
      ),
      body: BlocBuilder<SongCubit, SongState>(
        builder: (context, state) {
          if (state is SongLoading) {
            return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)));
          } else if (state is SongLoaded) {
            SongEntity song = state.song;

            if (_titleController.text != song.title) {
              _updateTitleController(song.title);
            }

            return Column(
              children: [
                SongPictureWidget(
                  isHovering: isHovering,
                  selectedImage: _selectedImage,
                  trackImageUrl: _trackImageUrl,
                  onTap: _handleImageTap,
                  onLongPress: _onLongPress,
                  onLongPressEnd: _onLongPressEnd,
                  showFilter: true,
                ),
                Expanded(
                  child: Column(
                    children: [
                      CustomTextField(label: 'Title', controller: _titleController, maxLength: 100, currentLength: _titleController.text.length),
                      UploadsOptionWidget(text: 'Pick genre', title: selectedGenre ?? 'Select genre', icon: Icons.arrow_forward_ios, onTap: _selectGenre),
                      UploadsOptionWidget(text: 'Description', title: description, icon: Icons.arrow_forward_ios, onTap: _navigateToDescriptionPage),
                      UploadsOptionWidget(text: 'Caption', title: caption, icon: Icons.arrow_forward_ios, onTap: _navigateToCaptionPage),
                      SizedBox(height: 20),
                      PrivacySettingWidget(isPublic: _isPublic, onToggle: _togglePrivacySetting),
                      SizedBox(height: 10),
                      _buildDeleteSong(song.songId),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('No song selected'));
          }
        },
      ),
    );
  }

  Widget _buildDeleteSong(String trackId) {
    return InkWell(
      onTap: () {
        showDeleteTrackDialog(context, trackId, onTrackDeleted);
      },
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(MonoIcons.delete, color: AppColors.red),
            SizedBox(width: 8),
            Text('Delete track', style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w200, color: AppColors.red)),
          ],
        ),
      ),
    );
  }
}
