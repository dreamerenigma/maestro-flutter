import 'dart:io';
import 'package:flutter/material.dart';
import 'package:maestro/features/home/screens/upload_tracks_screen.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:typed_data';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_colors.dart';
import '../../library/screens/library/tracks/edit_track_screen.dart';

class ChoosePictureScreen extends StatefulWidget {
  final AssetEntity image;
  final bool fromEditTrackScreen;

  const ChoosePictureScreen({super.key, required this.image, required this.fromEditTrackScreen});

  @override
  ChoosePictureScreenState createState() => ChoosePictureScreenState();
}

class ChoosePictureScreenState extends State<ChoosePictureScreen> {
  double _scale = 1.0;
  final TransformationController _transformationController = TransformationController();
  File? _selectedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(title: Text(S.of(context).chooseImage), hideBack: true),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<Uint8List?>(
              future: widget.image.originBytes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data != null) {
                    return Center(
                      child: GestureDetector(
                        onDoubleTap: _handleDoubleTap,
                        child: InteractiveViewer(
                          panEnabled: true,
                          minScale: 1.0,
                          maxScale: 4.0,
                          scaleEnabled: true,
                          transformationController: _transformationController,
                          child: Image.memory(
                            snapshot.data!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(child: Text(S.of(context).failedLoadImage));
                  }
                } else {
                  return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)));
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(S.of(context).cancel, style: TextStyle(fontSize: AppSizes.fontSizeMd, color: AppColors.grey)),
                ),
                TextButton(
                  onPressed: () {
                    if (widget.fromEditTrackScreen) {
                      Navigator.pop(
                        context,
                        createPageRoute(
                          EditTrackScreen(
                            selectedImage: widget.image,
                          ),
                        ),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        createPageRoute(
                          UploadTracksScreen(
                            selectedImage: widget.image,
                            songName: '',
                            shouldSelectFileImmediately: true,
                            selectedFile: _selectedFile,
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(S.of(context).choose, style: TextStyle(fontSize: AppSizes.fontSizeMd, color: AppColors.grey)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleDoubleTap() {
    setState(() {
      _scale = _scale == 1.0 ? 2.0 : 1.0;
      _transformationController.value = Matrix4.identity()..scale(_scale);
    });
  }
}
