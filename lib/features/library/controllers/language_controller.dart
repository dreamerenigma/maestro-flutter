import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_images.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../generated/l10n/l10n.dart';

class LanguageController extends GetxController {
  static LanguageController get instance => Get.find();

  var selectedLanguage = 'ru'.obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    String? savedLanguage = box.read('selectedLanguage');
    if (savedLanguage != null) {
      selectedLanguage.value = savedLanguage;
      Get.updateLocale(Locale(savedLanguage));
    } else {
      selectedLanguage.value = 'ru';
    }
  }

  void setLanguage(String language) {
    selectedLanguage.value = language;
    box.write('selectedLanguage', language);
    Get.updateLocale(Locale(language));
  }

  Future<void> selectLanguage(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.youngNight : AppColors.lightBackground,
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
                  child: Text(S.of(context).selectLanguage, style: const TextStyle(fontSize: AppSizes.fontSizeLg, fontWeight: FontWeight.bold)),
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
                RadioListTile<String>(
                  title: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 6),
                    child: Row(
                      children: [
                        Image.asset(
                          AppImages.russiaFlag,
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(width: 16),
                        Text(S.of(context).russianLanguage),
                      ],
                    ),
                  ),
                  value: 'ru',
                  groupValue: selectedLanguage.value,
                  onChanged: (value) {
                    if (value != null) {
                      setLanguage(value);
                      Get.back();
                    }
                  },
                  controlAffinity: ListTileControlAffinity.trailing,
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppColors.blue,
                ),
                RadioListTile<String>(
                  title: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 6),
                    child: Row(
                      children: [
                        Image.asset(
                          AppImages.usaFlag,
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(width: 16),
                        Text(S.of(context).englishLanguage),
                      ],
                    ),
                  ),
                  value: 'en',
                  groupValue: selectedLanguage.value,
                  onChanged: (value) {
                    if (value != null) {
                      setLanguage(value);
                      Get.back();
                    }
                  },
                  controlAffinity: ListTileControlAffinity.trailing,
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppColors.blue,
                ),
                RadioListTile<String>(
                  title: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 6.0),
                    child: Row(
                      children: [
                        Image.asset(
                          AppImages.spainFlag,
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(width: 16),
                        Text(S.of(context).spanishLanguage),
                      ],
                    ),
                  ),
                  value: 'es',
                  groupValue: selectedLanguage.value,
                  onChanged: (value) {
                    if (value != null) {
                      setLanguage(value);
                      Get.back();
                    }
                  },
                  controlAffinity: ListTileControlAffinity.trailing,
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppColors.blue,
                ),
                const SizedBox(height: AppSizes.spaceBtwLittle),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
