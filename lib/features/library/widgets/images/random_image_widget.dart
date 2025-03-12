import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_images.dart';

class RandomImageWidget extends StatefulWidget {
  const RandomImageWidget({super.key});

  @override
  RandomImageWidgetState createState() => RandomImageWidgetState();
}

class RandomImageWidgetState extends State<RandomImageWidget> {
  late String selectedImage;

  final List<String> images = [
    AppImages.defaultCover1,
    AppImages.defaultCover2,
    AppImages.defaultCover3,
    AppImages.defaultCover4,
    AppImages.defaultCover5,
    AppImages.defaultCover6,
  ];

  @override
  void initState() {
    super.initState();
    final random = math.Random();
    final randomIndex = random.nextInt(images.length);
    selectedImage = images[randomIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.darkGrey, width: 0.8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          selectedImage,
          width: 65,
          height: 65,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
