import 'package:dartz/dartz.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import '../../../service_locator.dart';
import '../../../utils/usecase/usecase.dart';
import '../../repository/users/user_repository.dart';

class AddFollowingUseCases implements UseCase<Either<String, bool>, String> {
  @override
  Future<Either<String, bool>> call({String? params}) async {
    if (params == null) {
      return Left("User ID cannot be null");
    }
    return await sl<UserRepository>().addFollowing(RxBool(true), "currentUserId", params);
  }
}
