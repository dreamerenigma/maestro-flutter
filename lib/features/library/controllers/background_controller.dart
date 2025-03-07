import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class BackgroundController extends GetxController {
  var backgroundImageUrl = Rx<String?>(null);

  void setBackgroundImage(String url) {
    backgroundImageUrl.value = url;
  }
}
