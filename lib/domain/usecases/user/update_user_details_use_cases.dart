import 'package:maestro/domain/repository/users/user_repository.dart';
import '../../../service_locator.dart';
import '../../../utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class UpdateUserDetailsUseCases implements UseCase<Either<String, bool>, String> {

  @override
  Future<Either<String, bool>> call({String? params}) async {
    if (params == null) {
      return Left("User ID cannot be null");
    }
    return await sl<UserRepository>().updateUserDetails(params, {});
  }
}
