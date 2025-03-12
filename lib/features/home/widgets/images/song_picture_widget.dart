import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../../utils/constants/app_colors.dart';
import 'package:flutter/services.dart';

class SongPictureWidget extends StatefulWidget {
  final bool isHovering;
  final AssetEntity? selectedImage;
  final String? trackImageUrl;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onLongPressEnd;
  final bool showFilter;

  const SongPictureWidget({
    super.key,
    required this.isHovering,
    required this.selectedImage,
    this.trackImageUrl,
    required this.onTap,
    required this.onLongPress,
    required this.onLongPressEnd,
    required this.showFilter,
  });

  @override
  State<SongPictureWidget> createState() => _SongPictureWidgetState();
}

class _SongPictureWidgetState extends State<SongPictureWidget> {
  bool isHovering = false;

  void _onLongPress() {
    setState(() => isHovering = true);
  }

  void _onLongPressEnd() {
    setState(() => isHovering = false);
  }

  @override
  Widget build(BuildContext context) {
    log('trackImageUrl: ${widget.trackImageUrl}');
    log('selectedImage: ${widget.selectedImage}');

    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: () => _onLongPress(),
      onLongPressEnd: (_) => _onLongPressEnd(),
      child: Center(
        child: Container(
          width: 160.0,
          height: 160.0,
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(color: AppColors.darkerGrey, borderRadius: BorderRadius.circular(16.0)),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: widget.trackImageUrl != null
                    ? Image.network(
                        widget.trackImageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      )
                    : widget.selectedImage == null
                        ? const Center(child: Icon(Icons.camera_alt_outlined, size: 28, color: AppColors.black))
                        : FutureBuilder<Uint8List?>(
                            future: widget.selectedImage!.thumbnailData,
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
                                  log('Failed to load image from AssetEntity');
                                  return const Center(child: Text('Failed to load image'));
                                }
                              } else {
                                log('Loading image from AssetEntity...');
                                return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)));
                              }
                            },
                          ),
              ),
              if (widget.showFilter)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.white.withAlpha((0.3 * 255).toInt()),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              if (widget.isHovering)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.white.withAlpha((0.3 * 255).toInt()),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              if (widget.isHovering)
                Container(
                  width: 160.0,
                  height: 160.0,
                  decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(16.0)),
                  child: const Center(
                    child: Icon(Icons.camera_alt_outlined, size: 28, color: AppColors.black),
                  ),
                ),
              if (!widget.isHovering)
                const Center(child: Icon(Icons.camera_alt_outlined, size: 28, color: AppColors.black)),
            ],
          ),
        ),
      ),
    );
  }
}
