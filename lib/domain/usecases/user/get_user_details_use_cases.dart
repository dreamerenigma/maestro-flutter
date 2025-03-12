import 'package:maestro/domain/repository/users/user_repository.dart';
import '../../../features/home/models/user_model.dart';
import '../../../service_locator.dart';
import '../../../utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class GetUserDetailsUseCases implements UseCase<Either<String, UserModel>, String> {

  @override
  Future<Either<String, UserModel>> call({String? params}) async {
    if (params == null) {
      return Left("User ID cannot be null");
    }
    return await sl<UserRepository>().getUserDetails(params);
  }
}
