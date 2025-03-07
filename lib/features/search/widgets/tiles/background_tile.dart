import 'package:flutter/material.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../screens/genre_screen.dart';

class BackGroundTile extends StatelessWidget {
  final int initialIndex;
  final Color backgroundColor;
  final IconData icondata;
  final Color borderColor;
  final int index;
  final String text;

  const BackGroundTile({
    super.key,
    required this.initialIndex,
    required this.backgroundColor,
    required this.icondata,
    required this.borderColor,
    required this.index,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.youngNight,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(context, createPageRoute(GenreScreen(genreName: text, genreIcon: icondata, initialIndex: initialIndex)));
        },
        splashColor: AppColors.darkerGrey.withAlpha((0.1 * 255).toInt()),
        highlightColor: AppColors.darkerGrey.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(AppSizes.cardRadiusBg),
        child: Padding(
          padding: const EdgeInsets.only(left: 14, right: 14, top: 17),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  text,
                  style: const TextStyle(color: AppColors.white, fontSize: AppSizes.fontSizeLg, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                height: 34,
                width: 34,
                alignment: Alignment.center,
                child: Icon(icondata, color: AppColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

