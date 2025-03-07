import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:maestro/features/home/screens/select_pictures_screen.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import 'package:maestro/routes/custom_page_route.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../data/sources/song/song_firebase_service.dart';
import '../../../service_locator.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_colors.dart';
import '../../library/screens/library/caption_screen.dart';
import '../../library/screens/library/description_screen.dart';
import '../../library/screens/library/genre_screen.dart';
import '../../library/widgets/switches.dart';
import '../widgets/dialogs/cancel_upload_dialog.dart';
import 'package:audiotags/audiotags.dart';

class UploadTracksScreen extends StatefulWidget {
  final AssetEntity? selectedImage;
  final String songName;

  const UploadTracksScreen({super.key, required this.songName, this.selectedImage});

  @override
  UploadTracksScreenState createState() => UploadTracksScreenState();
}

class UploadTracksScreenState extends State<UploadTracksScreen> {
  final GetStorage _storageBox = GetStorage();
  double _uploadProgress = 0.0;
  final TextEditingController _titleController = TextEditingController();
  bool _isPublic = true;
  bool isTrackSelected = false;
  bool isHovering = false;
  AssetEntity? _selectedImage;
  String? selectedGenre;
  String description = 'Describe your track';
  String caption = 'Add a caption to your post (optional)';
  File? _selectedFile;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.selectedImage;
    _loadPrivacySetting();
    _startUpload();
    _titleController.text = widget.songName;
    _titleController.addListener(_updateTitleCount);
  }

  void _loadPrivacySetting() {
    _isPublic = _storageBox.read('isPublic') ?? true;
  }

  void _savePrivacySetting() {
    _storageBox.write('isPublic', _isPublic);
  }

  void _startUpload() {
    Future.delayed(const Duration(seconds: 1), _updateProgress);
  }

  void _updateProgress() {
    setState(() {
      _uploadProgress += 0.1;
      if (_uploadProgress < 1.0) {
        Future.delayed(const Duration(seconds: 1), _updateProgress);
      } else {
        _uploadProgress = 1.0;
      }
    });
  }

  void _updateTitleCount() {
    setState(() {});
  }

  void _toggleSwitch(bool value) {
    setState(() {
      _isPublic = value;
      _savePrivacySetting();
    });
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

  Future<void> _uploadTrack() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No file selected')),
      );
      return;
    }

    try {
      if (await _selectedFile!.exists()) {
        String fileName = _selectedFile!.path.split('/').last;
        Reference storageReference = FirebaseStorage.instance.ref().child('songs/$fileName');

        UploadTask uploadTask = storageReference.putFile(_selectedFile!);

        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          setState(() {
            _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
          });
        });

        AudioPlayer audioPlayer = AudioPlayer();
        Duration? duration = await audioPlayer.setFilePath(_selectedFile!.path);
        duration ??= Duration(seconds: 0);

        var audioFile = await AudioTags.read(_selectedFile!.path);
        String title = audioFile?.title ?? 'Unknown Title';
        String genre = audioFile?.genre ?? 'Unknown Title';

        String coverURL = '';
        List<Picture>? pictures = audioFile?.pictures;

        if (pictures != null && pictures.isNotEmpty) {
          Picture coverPicture = pictures.first;

          Uint8List? coverBytes = coverPicture.bytes;

          Reference coverStorageReference = FirebaseStorage.instance.ref().child('covers/$fileName.jpg');
          UploadTask coverUploadTask = coverStorageReference.putData(coverBytes);

          await coverUploadTask.whenComplete(() async {
            coverURL = await coverStorageReference.getDownloadURL();
            log('Cover image uploaded: $coverURL');
          });
                }

        await uploadTask.whenComplete(() async {
          if (!mounted) return;

          String fileURL = await storageReference.getDownloadURL();
          log('File uploaded to Firebase Storage: $fileURL');

          await sl<SongFirebaseService>().addOrRemoveFavoriteSongs(fileName);

          int trackDurationInSeconds = duration?.inSeconds ?? 0;
          int minutes = trackDurationInSeconds ~/ 60;
          int seconds = trackDurationInSeconds % 60;

          String formattedDuration = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

          log('Calling _uploadTrackMetadata function');
          await _uploadTrackMetadata(title, genre, formattedDuration, coverURL, fileURL, duration);

          log('Track metadata uploaded to Firestore');
          Get.snackbar('Success', 'File $fileName uploaded successfully', snackPosition: SnackPosition.TOP, backgroundColor: Colors.green, colorText: AppColors.white);
        });
      } else {
        log("File does not exist at the provided path.");
        Get.snackbar('Error', 'File not found', snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      log('Failed to upload track: $e');
      Get.snackbar('Error', 'Failed to upload track', snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> _uploadTrackMetadata(String title, String genre, String duration, String coverURL, String fileURL, Duration? durationObj) async {
    try {
      int trackDurationInSeconds = durationObj?.inSeconds ?? 0;
      int minutes = trackDurationInSeconds ~/ 60;
      int seconds = trackDurationInSeconds % 60;

      String formattedDuration = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

      log('Uploading track metadata to Firestore');
      log('Title: $title, Duration: $formattedDuration, CoverURL: $coverURL, FileURL: $fileURL');

      log('Preparing to add data to Firestore');
      await FirebaseFirestore.instance.collection('Songs').add({
        'title': title,
        'genre': genre,
        'description': description,
        'caption': caption,
        'duration': formattedDuration,
        'cover': coverURL,
        'fileURL': fileURL,
        'releaseDate': Timestamp.now(),
        'listenCount': 0,
        'uploadedBy': FirebaseAuth.instance.currentUser?.uid,
      });

      log('Track metadata uploaded to Firestore');
    } catch (e) {
      log('Error uploading track metadata to Firestore: $e');
      rethrow;
    }
  }

  Future<void> _selectMusicFile() async {
    await Permission.storage.request();

    if (await Permission.storage.isGranted) {

      String initialDirectory = "/storage/emulated/0/Sounds";

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'aac', 'wav', 'flac', 'alac', 'dsd', 'ogg'],
        initialDirectory: initialDirectory,
      );

      if (result != null) {
        String? filePath = result.files.single.path;

        if (filePath != null && filePath.isNotEmpty) {
          setState(() {
            _selectedFile = File(filePath);
            isTrackSelected = true;
          });
        } else {
          log("File path is null or empty.");
        }
      } else {
        log("No file selected");
      }
    } else {
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        centerTitle: false,
        saveButtonText: 'Save',
        onSavePressed: _uploadTrack,
        onBackPressed: () {
          showCancelUploadDialog(context);
        },
        actions: [
          IconButton(
            onPressed: _selectMusicFile,
            icon: const Icon(Icons.audiotrack, size: 22, color: AppColors.grey),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cast, size: 22, color: AppColors.grey),
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  ListView(
                    children: [
                      if (isTrackSelected && _uploadProgress >= 1.0) _uploading(), const SizedBox(height: 20),
                      if (isTrackSelected && _uploadProgress < 1.0) _ready(),
                      _songPicture(() {
                        Navigator.push(context, createPageRoute(SelectPicturesScreen()));
                      }),
                      _buildTextField('Title', _titleController, maxLength: 100, currentLength: _titleController.text.length),
                      _buildUploadsOption('Pick genre', selectedGenre ?? 'Select genre', Icons.arrow_forward_ios, _selectGenre),
                      _buildUploadsOption('Description', description, Icons.arrow_forward_ios, _navigateToDescriptionPage),
                      _buildUploadsOption('Caption', caption, Icons.arrow_forward_ios, _navigateToCaptionPage),
                      SizedBox(height: 20),
                      _privacySetting(),
                    ],
                  ),
                  if (_uploadProgress >= 1.0)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(),
                      child: _ready(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _uploading() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: double.infinity,
        color: AppColors.red,
        padding: const EdgeInsets.all(4),
        child: Text(
          'Uploading ${(_uploadProgress * 100).toStringAsFixed(0)}%',
          style: const TextStyle(fontSize: AppSizes.fontSizeMd, color: AppColors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _ready() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: double.infinity,
        color: AppColors.red,
        padding: const EdgeInsets.all(4),
        child: const Text(
          'Your track is ready. Tap Save to continue.',
          style: TextStyle(fontSize: AppSizes.fontSizeMd, color: AppColors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _songPicture(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () => setState(() => isHovering = true),
      onLongPressEnd: (_) => setState(() => isHovering = false),
      child: Center(
        child: Container(
          width: 160.0,
          height: 160.0,
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.darkerGrey,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: _selectedImage == null
                  ? const Center(child: Icon(Icons.camera_alt_outlined, size: 30, color: AppColors.white))
                  : FutureBuilder<Uint8List?>(
                    future: _selectedImage!.thumbnailData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.data != null) {
                          return LayoutBuilder(
                            builder: (context, constraints) {
                              return Image.memory(
                                snapshot.data!,
                                fit: BoxFit.cover,
                                width: constraints.maxWidth,
                                height: constraints.maxHeight,
                              );
                            },
                          );
                        } else {
                          return const Center(child: Text('Failed to load image'));
                        }
                      } else {
                        return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)));
                      }
                    },
                  ),
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.black.withAlpha((0.5 * 255).toInt()),
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              if (isHovering)
                Container(
                  width: 160.0,
                  height: 160.0,
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: const Center(
                    child: Icon(Icons.camera_alt_outlined, size: 30.0, color: AppColors.white),
                  ),
                ),
              if (!isHovering) const Center(child: Icon(Icons.camera_alt_outlined, size: 30, color: AppColors.white)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {required int maxLength, required int currentLength}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.w200, height: 0.1, letterSpacing: -0.7)),
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
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.white)),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
              style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w400),
              textCapitalization: TextCapitalization.sentences,
              onChanged: (text) {
                setState(() {});
              },
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('$currentLength/$maxLength', style: const TextStyle(color: AppColors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadsOption(String text, String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text, style: const TextStyle(fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.normal, letterSpacing: -0.7, color: AppColors.lightGrey)),
                  Text(title, style: const TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.normal, letterSpacing: -0.5)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Icon(icon, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _privacySetting() {
    return InkWell(
      onTap: () {
        setState(() {
          _isPublic = !_isPublic;
          _savePrivacySetting();
        });
      },
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Make this track public', style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
            const SizedBox(width: 80),
            CustomSwitch(
              value: _isPublic,
              onChanged: _toggleSwitch,
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
