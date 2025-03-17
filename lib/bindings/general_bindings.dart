import 'package:get/get.dart';
import 'package:maestro/features/library/controllers/language_controller.dart';
import 'package:maestro/features/library/controllers/profile_image_controller.dart';
import 'package:maestro/features/library/controllers/themes_controller.dart';

import '../features/library/controllers/playlist_image_controller.dart';
import '../features/search/controllers/user_params_controller.dart';

class GeneralBindings extends Bindings {

  @override
  void dependencies() {
    Get.put(LanguageController());
    Get.put(ThemesController());
    Get.put(PlaylistImageController());
    Get.put(ProfileImageController());
    Get.put(UserParamsController());
  }
}
