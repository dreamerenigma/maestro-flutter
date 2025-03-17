import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:maestro/common/widgets/app_bar/app_bar.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import 'package:maestro/utils/constants/app_colors.dart';
import 'package:weather_icons/weather_icons.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../choose_mode/bloc/theme_cubit.dart';

class InterfaceStyleScreen extends StatelessWidget {
  const InterfaceStyleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return Scaffold(
          appBar: const BasicAppBar(
            title: Text('Interface style', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
            centerTitle: false,
          ),
          body: ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  _buildThemeOption(
                    context,
                    icon: Ionicons.settings_outline,
                    iconSize: 28,
                    label: 'System Default',
                    themeMode: ThemeMode.system,
                    currentMode: themeMode,
                    horizontalSpacing: 16,
                  ),
                  _buildThemeOption(
                    context,
                    icon: WeatherIcons.day_sunny,
                    iconSize: 24,
                    label: 'Light',
                    themeMode: ThemeMode.light,
                    currentMode: themeMode,
                    horizontalSpacing: 20,
                  ),
                  _buildThemeOption(
                    context,
                    icon: BootstrapIcons.moon,
                    iconSize: 24,
                    label: 'Dark',
                    themeMode: ThemeMode.dark,
                    currentMode: themeMode,
                    horizontalSpacing: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(BuildContext context, {
    required IconData icon,
    required double iconSize,
    required String label,
    required ThemeMode themeMode,
    required ThemeMode currentMode,
    required double horizontalSpacing,
  }) {
    return InkWell(
      onTap: () {
        context.read<ThemeCubit>().updateTheme(themeMode);
      },
      splashColor: context.isDarkMode ? AppColors.darkGrey.withAlpha((0.4 * 255).toInt()) : AppColors.grey.withAlpha((0.4 * 255).toInt()),
      highlightColor: context.isDarkMode ? AppColors.darkGrey.withAlpha((0.4 * 255).toInt()) : AppColors.grey.withAlpha((0.4 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: iconSize, color: context.isDarkMode ? AppColors.white : AppColors.black),
            SizedBox(width: horizontalSpacing),
            Expanded(
              child: Text(label, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.normal)),
            ),
            if (currentMode == themeMode)
              Icon(Icons.check, color: context.isDarkMode ? AppColors.white : AppColors.black, size: 22),
          ],
        ),
      ),
    );
  }
}
