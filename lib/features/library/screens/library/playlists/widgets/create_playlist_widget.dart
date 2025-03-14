import 'package:flutter/material.dart';
import 'package:maestro/utils/constants/app_sizes.dart';
import '../../../../../../utils/constants/app_colors.dart';

class CreatePlaylistWidget extends StatelessWidget {
  final VoidCallback onPlaylistCreated;

  const CreatePlaylistWidget({super.key, required this.onPlaylistCreated});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPlaylistCreated,
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 14),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(color: AppColors.steelGrey, borderRadius: BorderRadius.circular(8.0)),
                child: Icon(Icons.add_circle_outline, color: AppColors.lightGrey, size: 30),
              ),
            ),
            SizedBox(width: 16.0),
            Text('Create playlist', style: TextStyle(fontSize: AppSizes.fontSizeMd)),
          ],
        ),
      ),
    );
  }
}
