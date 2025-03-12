import 'dart:developer';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class PlaylistImageController extends GetxController {
  var playlistImageUrl = Rx<String?>(null);

  void setPlaylistImage(String url) {
    log("Setting playlist image: $url");
    playlistImageUrl.value = url;
  }
}
