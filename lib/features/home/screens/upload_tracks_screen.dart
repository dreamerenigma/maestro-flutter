import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:maestro/features/home/screens/select_pictures_screen.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import 'package:maestro/routes/custom_page_route.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../api/apis.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../common/widgets/input_fields/custom_text_field.dart';
import '../../../utils/constants/app_images.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_colors.dart';
import '../../library/screens/library/caption_screen.dart';
import '../../library/screens/library/description_screen.dart';
import '../../library/screens/library/genre_screen.dart';
import '../widgets/dialogs/cancel_upload_dialog.dart';
import 'package:audiotags/audiotags.dart';
import '../widgets/dialogs/no_internet_dialog.dart';
import '../widgets/images/song_picture_widget.dart';
import '../widgets/options/option_widget.dart';
import '../widgets/privacy_setting_widget.dart';
import 'package:path/path.dart' as path;

class UploadTracksScreen extends StatefulWidget {
  final AssetEntity? selectedImage;
  final String songName;
  final bool shouldSelectFileImmediately;
  final File? selectedFile;
  final Future<void> Function()? selectMusicFile;

  const UploadTracksScreen({
    super.key,
    this.selectedImage,
    required this.songName,
    required this.shouldSelectFileImmediately,
    this.selectedFile,
    this.selectMusicFile,
  });

  @override
  UploadTracksScreenState createState() => UploadTracksScreenState();
}

class UploadTracksScreenState extends State<UploadTracksScreen> {
  final GetStorage _storageBox = GetStorage();
  double _uploadProgress = 0.0;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isPublic = true;
  bool isTrackSelected = false;
  bool isHovering = false;
  bool _isFileSelected = false;
  AssetEntity? _selectedImage;
  String? _selectedFileName;
  String? selectedGenre;
  String description = 'Describe your track';
  String caption = 'Add a caption to your post (optional)';
  File? _selectedFile;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
    _selectedImage = widget.selectedImage;
    _loadPrivacySetting();
    _startUpload();
    _titleController.text = widget.songName;
    _titleController.addListener(_updateTitleCount);

    log("Selected file in UploadTracksScreen: ${widget.selectedFile?.path ?? 'No file selected'}");

    if (widget.shouldSelectFileImmediately) {
      if (_isConnected) {
        _selectMusicFile();
      }
    }
  }

  Future<void> _checkInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });

    if (!_isConnected) {
      showNoInternetDialog(context);
    }
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

  Future<void> _onFileSelected() async {
    if (_selectedFile != null) {
      String fileName = _selectedFile!.path.split('/').last;
      path.extension(fileName);
      _titleController.text = fileName;
    }
  }


  void _handleImageTap() {
    Navigator.pushReplacement(context, createPageRoute(SelectPicturesScreen(fromEditTrackScreen: false)));
  }

  void _onLongPress() {
    setState(() => isHovering = true);
  }

  void _onLongPressEnd() {
    setState(() => isHovering = false);
  }

  void _updateTitleCount() {
    setState(() {});
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

  void _togglePrivacySetting(bool value) {
    setState(() {
      _isPublic = value;
      _savePrivacySetting();
    });
  }

  Future _getCurrentUserCoverURL() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      var userDoc = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();

      if (userDoc.exists) {
        var userData = userDoc.data();
        return userData?['image'];
      } else {
        return null;
      }
    } catch (e) {
      log('Failed to get user image URL: $e');
      return null;
    }
  }

  Future<String> _uploadCoverImage(String fileName, String? coverBase64) async {
    String coverURL = '';
    String? currentUserCoverURL = await _getCurrentUserCoverURL();

    if (currentUserCoverURL != null && currentUserCoverURL.isNotEmpty) {
      coverURL = currentUserCoverURL;
    } else {
      if (coverBase64 != null) {
        Uint8List coverBytes = base64Decode(coverBase64);
        Reference coverStorageReference = FirebaseStorage.instance.ref().child('covers/$fileName.jpg');

        UploadTask coverUploadTask = coverStorageReference.putData(coverBytes);

        await coverUploadTask.whenComplete(() async {
          coverURL = await coverStorageReference.getDownloadURL();
        });
      } else {
        ByteData data = await rootBundle.load(AppImages.defaultCover1);
        Uint8List defaultCoverBytes = data.buffer.asUint8List();

        Reference defaultCoverStorageReference = FirebaseStorage.instance.ref().child('covers/$fileName.jpg');
        UploadTask defaultCoverUploadTask = defaultCoverStorageReference.putData(defaultCoverBytes);

        await defaultCoverUploadTask.whenComplete(() async {
          coverURL = await defaultCoverStorageReference.getDownloadURL();
        });
      }
    }

    return coverURL;
  }

  Future<void> _selectMusicFile() async {
    if (!_isConnected) {
      return;
    }

    if (_isFileSelected) return;
    setState(() {
      _isFileSelected = true;
    });

    var permissionStatus = await Permission.manageExternalStorage.request();
    log('Storage permission status: $permissionStatus');

    if (permissionStatus.isGranted) {
      log('Permission granted, opening file picker...');

      Directory? directory = await getExternalStorageDirectory();
      String initialDirectory = directory?.path ?? "/storage/emulated/0/Sounds";

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'aac', 'wav', 'flac', 'alac', 'dsd', 'ogg'],
        initialDirectory: initialDirectory,
      );

      log('File picker result: $result');

      if (result != null && result.files.isNotEmpty) {
        String? filePath = result.files.single.path;

        if (filePath != null && filePath.isNotEmpty) {
          setState(() {
            _selectedFile = File(filePath);
            String fileName = _selectedFile!.path.split('/').last;
            _selectedFileName = fileName.split('.').first;

            if (_titleController.text.isEmpty) {
              _titleController.text = _selectedFileName!;
            }

            _onFileSelected();
          });
          log("File selected: $filePath");
        } else {
          log("File path is null or empty.");
        }
      } else {
        log("No file selected");
      }
    } else {
      log('Storage permission denied or not granted.');
      openAppSettings();
    }
  }

  Future<void> _updateTracksCount(String userId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();

      if (userSnapshot.exists) {
        var data = userSnapshot.data() as Map<String, dynamic>;

        int tracksCount = data['tracksCount'] ?? 0;

        tracksCount++;

        await FirebaseFirestore.instance.collection('Users').doc(user.uid).update({
          'tracksCount': tracksCount,
        });

        log('Tracks count updated for user: $userId');
      } else {
        log('User not found');
      }
    } catch (e) {
      log('Error updating tracks count: $e');
    }
  }

  Future<String?> _getArtistFromTrack(String filePath) async {
    try {
      var audioFile = await AudioTags.read(filePath);

      log('Audio File Metadata: $audioFile');

      String? artist = audioFile?.trackArtist ?? audioFile?.albumArtist;

      if (artist == null || artist == 'Unknown Artist') {
        String? title = filePath.split('/').last;
        artist = _getArtistFromTitle(title);
      }

      return artist ?? 'Unknown Artist';
    } catch (e) {
      log('Error reading artist from track: $e');
      return 'Unknown Artist';
    }
  }

  String? _getArtistFromTitle(String? title) {
    if (title != null && title.contains('-')) {
      final parts = title.split('-');
      if (parts.length > 1) {
        return parts[0].trim();
      }
    }
    return null;
  }

  Future<void> _uploadTrack(String description, String caption) async {
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
        String? coverBase64 = audioFile?.album;

        String? artist = await _getArtistFromTrack(_selectedFile!.path);
        String coverURL = await _uploadCoverImage(fileName, coverBase64);

        if (coverBase64 != null) {
          Uint8List coverBytes = base64Decode(coverBase64);
          Reference coverStorageReference = FirebaseStorage.instance.ref().child('covers/$fileName.jpg');
          UploadTask coverUploadTask = coverStorageReference.putData(coverBytes);

          await coverUploadTask.whenComplete(() async {
            coverURL = await coverStorageReference.getDownloadURL();
          });
        }

        await uploadTask.whenComplete(() async {
          String fileURL = await storageReference.getDownloadURL();
          log('File Uploaded: $fileURL');

          String title = _titleController.text;
          String genre = selectedGenre ?? 'Unknown';

          int trackDurationInSeconds = duration?.inSeconds ?? 0;
          int minutes = trackDurationInSeconds ~/ 60;
          int seconds = trackDurationInSeconds % 60;
          String formattedDuration = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

          String uploadedBy = await APIs.getUserName();

          await _uploadTrackMetadata(title, artist, genre, formattedDuration, coverURL, fileURL, _isPublic, uploadedBy);

          await _updateTracksCount(uploadedBy);

          log('Upload Complete');

          Get.snackbar('Success', 'Upload Complete');
        });
      } else {
        log("File does not exist at the provided path.");
        Get.snackbar('Warning', 'File not found');
      }
    } catch (e) {
      log('Failed to upload track: $e');
      Get.snackbar('Failed', 'Failed to upload track');
    }
  }

  Future<void> _uploadTrackMetadata(
    String title,
    String? artist,
    String genre,
    String duration,
    String coverURL,
    String fileURL,
    bool isPublic,
    String uploadedBy,
  ) async {
    try {

      await FirebaseFirestore.instance.collection('Songs').add({
        'title': title,
        'artist': artist ?? 'Unknown Artist',
        'genre': genre,
        'description': description,
        'caption': caption,
        'isPublic': isPublic,
        'duration': duration,
        'cover': coverURL,
        'fileURL': fileURL,
        'releaseDate': Timestamp.now(),
        'listenCount': 0,
        'uploadedBy': uploadedBy,
      });

      log('Track metadata uploaded to Firestore');
    } catch (e) {
      log('Error uploading track metadata to Firestore: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        centerTitle: false,
        saveButtonText: 'Save',
        onSavePressed: () async {
          await _uploadTrack(description, caption);
        },
        onBackPressed: () {
          showCancelUploadDialog(context);
        },
        actions: [
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
                      if (_uploadProgress < 1.0) _uploading(), const SizedBox(height: 20),
                      if (_uploadProgress >= 1.0) _ready(),
                      SongPictureWidget(
                        isHovering: isHovering,
                        selectedImage: _selectedImage,
                        onTap: _handleImageTap,
                        onLongPress: _onLongPress,
                        onLongPressEnd: _onLongPressEnd,
                        showFilter: false,
                      ),
                      CustomTextField(label: 'Title', controller: _titleController, maxLength: 100, currentLength: _titleController.text.length),
                      UploadsOptionWidget(text: 'Pick genre', title: selectedGenre ?? 'Select genre', icon: Icons.arrow_forward_ios, onTap: _selectGenre),
                      UploadsOptionWidget(text: 'Description', title: description, icon: Icons.arrow_forward_ios, onTap: _navigateToDescriptionPage),
                      UploadsOptionWidget(text: 'Caption', title: caption, icon: Icons.arrow_forward_ios, onTap: _navigateToCaptionPage),
                      SizedBox(height: 20),
                      PrivacySettingWidget(isPublic: _isPublic, onToggle: _togglePrivacySetting),
                    ],
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
}
