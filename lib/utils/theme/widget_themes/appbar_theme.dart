import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_colors.dart';

class AppAppBarTheme{
  AppAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: AppColors.transparent,
    surfaceTintColor: AppColors.transparent,
    iconTheme: IconThemeData(color: AppColors.youngNight, size: AppSizes.iconXl),
    actionsIconTheme: IconThemeData(color: AppColors.youngNight, size: AppSizes.iconXl),
    titleTextStyle: TextStyle(fontSize: AppSizes.fontSizeLg, fontWeight: FontWeight.w600, color: AppColors.black),
  );
  static const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: AppColors.transparent,
    surfaceTintColor: AppColors.transparent,
    iconTheme: IconThemeData(color: AppColors.youngNight, size: AppSizes.iconXl),
    actionsIconTheme: IconThemeData(color: AppColors.white, size: AppSizes.iconXl),
    titleTextStyle: TextStyle(fontSize: AppSizes.fontSizeLg, fontWeight: FontWeight.w600, color: AppColors.white),
  );
}