import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import '../../../../../../domain/entities/station/station_entity.dart';
import '../../../../../../utils/constants/app_colors.dart';
import '../../../../../../utils/constants/app_sizes.dart';

class StationActionIconsWidget extends StatefulWidget {
  final List<StationEntity> station;
  final bool isShuffleActive;
  final VoidCallback toggleShuffle;

  const StationActionIconsWidget({
    super.key,
    required this.station,
    required this.isShuffleActive,
    required this.toggleShuffle,
  });

  @override
  StationActionIconsWidgetState createState() => StationActionIconsWidgetState();
}

class StationActionIconsWidgetState extends State<StationActionIconsWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 20, bottom: 12),
      child: Row(
        children: [
          InkWell(
            onTap: () {},
            splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
            highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
            borderRadius: BorderRadius.circular(AppSizes.cardRadiusXl),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(Icons.favorite_border_rounded, size: AppSizes.iconLg),
                  SizedBox(width: 5),
                  Text('0', style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w200)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 20),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, size: AppSizes.iconLg),
            onPressed: () {},
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              BootstrapIcons.shuffle,
              color: widget.isShuffleActive ? AppColors.primary : AppColors.white,
              size: AppSizes.iconMd,
            ),
            onPressed: widget.toggleShuffle,
          ),
          const SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).brightness == Brightness.light ? AppColors.lightGrey : AppColors.white,
            ),
            child: IconButton(
              icon: Icon(
                Icons.play_arrow_rounded,
                color: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
                size: 32,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
