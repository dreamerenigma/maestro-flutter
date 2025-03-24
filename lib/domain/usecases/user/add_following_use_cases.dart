import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import '../../../features/search/controllers/user_params_controller.dart';
import '../../../service_locator.dart';
import '../../../utils/usecase/usecase.dart';
import '../../repository/users/user_repository.dart';

class AddFollowingUseCases implements UseCase<Either<String, bool>, String> {
  @override
  Future<Either<String, bool>> call({String? params}) async {
    if (params == null) {
      return Left("User ID cannot be null");
    }

    final userParamsController = Get.find<UserParamsController>();
    final userParams = userParamsController.userParamsValue;

    if (userParams == null || userParams.currentUserId.isEmpty || params.isEmpty) {
      log("Error: User IDs are missing or empty");
      return Left("User IDs are missing or empty");
    }

    final currentUserId = userParams.currentUserId;
    final targetUserId = params;

    return await sl<UserRepository>().addFollowing(RxBool(true), currentUserId, targetUserId);
  }
}

