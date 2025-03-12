import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../../../../../utils/constants/app_colors.dart';
import '../../../../../../utils/constants/app_images.dart';
import '../../../../../../utils/constants/app_sizes.dart';
import '../../../profile/widgets/image_dialog.dart';

class CoverStationWidget extends StatelessWidget {
  final Map<String, dynamic> userData;

  const CoverStationWidget({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    final userName = userData['name'] as String?;

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 6, top: 16, bottom: 6),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              showImageDialog(context, AppImages.playlist);
            },
            splashColor: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
            highlightColor: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
            borderRadius: BorderRadius.circular(AppSizes.cardRadiusSm),
            child: Container(
              width: 115,
              height: 115,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.darkGrey.withAlpha((0.5 * 255).toInt()),
                border: Border.all(color: AppColors.darkGrey),
                image: DecorationImage(
                  image: AssetImage(AppImages.playlist),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('STATION', style: TextStyle(color: AppColors.white, fontSize: 11, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontFamily: 'Roboto')),
                      Text('$userName', style: TextStyle(color: AppColors.lightGrey, fontSize: 10, height: 1)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$userName', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Icon(BoxIcons.bx_station, size: 20),
                  SizedBox(width: 4),
                  Text('Artist station · 2:55:12', style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, fontFamily: 'Roboto')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
