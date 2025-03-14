import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ionicons/ionicons.dart';
import 'package:weather_icons/weather_icons.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../generated/l10n/l10n.dart';

class ThemesController extends GetxController {
  static ThemesController get instance => Get.find();

  var selectedThemes = 'light'.obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    selectedThemes.value = box.read('selectedThemes') ?? 'light';
    applyTheme(selectedThemes.value);
    ever(selectedThemes, (value) {
      applyTheme(value);
    });
  }

  ThemeMode getThemeMode() {
    switch (selectedThemes.value) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }

  void setThemes(String theme) {
    selectedThemes.value = theme;
    box.write('selectedThemes', theme);
    applyTheme(theme);
  }

  void applyTheme(String theme) {
    if (theme == 'light') {
      Get.changeThemeMode(ThemeMode.light);
    } else if (theme == 'dark') {
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      Get.changeThemeMode(ThemeMode.system);
    }
  }

  Future<void> selectThemes(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (_) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16, top: 10, bottom: 10),
                  child: Text(S.of(context).selectTheme, style: TextStyle(fontSize: AppSizes.fontSizeLg, fontWeight: FontWeight.bold)),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const Divider(),
            Obx(() => Column(
              children: [
                _buildThemeOption(
                  context,
                  icon: WeatherIcons.day_sunny,
                  text: S.of(context).light,
                  value: 'light',
                ),
                _buildThemeOption(
                  context,
                  icon: BootstrapIcons.moon,
                  text: S.of(context).dark,
                  value: 'dark',
                ),
                _buildThemeOption(
                  context,
                  icon: Ionicons.settings_outline,
                  text: S.of(context).system,
                  value: 'system',
                ),
                SizedBox(height: AppSizes.spaceBtwLittle),
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(BuildContext context, {
    required IconData icon,
    required String text,
    required String value,
  }) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: () {
          setThemes(value);
          Get.back();
        },
        splashColor: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
        highlightColor: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: RadioListTile<String>(
            title: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 6),
              child: Row(
                children: [
                  Icon(icon),
                  const SizedBox(width: 16),
                  Text(text, style: TextStyle(fontSize: AppSizes.fontSizeMd)),
                ],
              ),
            ),
            value: value,
            groupValue: selectedThemes.value,
            onChanged: (newValue) {
              if (newValue != null) {
                setThemes(newValue);
                Get.back();
              }
            },
            controlAffinity: ListTileControlAffinity.trailing,
            contentPadding: EdgeInsets.zero,
            activeColor: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
