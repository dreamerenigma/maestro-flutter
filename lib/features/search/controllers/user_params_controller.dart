import 'dart:developer';
import 'package:get/get.dart';
import '../../../domain/params/user/user_params.dart';

class UserParamsController extends GetxController {
  var userParams = Rxn<UserParams>();

  void setUserParams(String currentUserId, String targetUserId) {
    log('Setting user params: currentUserId=$currentUserId, targetUserId=$targetUserId');
    userParams.value = UserParams(
      currentUserId: currentUserId,
      targetUserId: targetUserId,
    );
  }

  UserParams? get userParamsValue => userParams.value;
}
