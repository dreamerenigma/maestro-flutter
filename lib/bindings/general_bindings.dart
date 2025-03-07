import 'package:get/get.dart';
import 'package:maestro/features/library/controllers/language_controller.dart';
import 'package:maestro/features/library/controllers/themes_controller.dart';

class GeneralBindings extends Bindings {

  @override
  void dependencies() {
    Get.put(LanguageController());
    Get.put(ThemesController());
  }
}
