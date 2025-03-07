import 'package:flutter/material.dart';
import 'package:maestro/features/home/screens/upload_tracks_screen.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:typed_data';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_colors.dart';

class ChoosePictureScreen extends StatefulWidget {
  final AssetEntity image;

  const ChoosePictureScreen({super.key, required this.image});

  @override
  ChoosePictureScreenState createState() => ChoosePictureScreenState();
}

class ChoosePictureScreenState extends State<ChoosePictureScreen> {
  double _scale = 1.0;
  final TransformationController _transformationController = TransformationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppBar(
        title: Text('Choose Image'),
        hideBack: true,
      ),
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
                    return const Center(child: Text('Failed to load image'));
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
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: AppSizes.fontSizeMd, color: AppColors.grey),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, createPageRoute(UploadTracksScreen(selectedImage: widget.image, songName: '')));
                  },
                  child: const Text('Choose', style: TextStyle(fontSize: AppSizes.fontSizeMd, color: AppColors.grey),),
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
