import 'dart:developer';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ProfileImageController extends GetxController {
  var profileImageUrl = Rx<String?>(null);

  void setProfileImage(String url) {
    log("Setting profile image: $url");
    profileImageUrl.value = url;
  }
}
