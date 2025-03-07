import 'package:dartz/dartz.dart';
import 'package:maestro/features/authentication/models/create_user_req.dart';
import 'package:maestro/domain/repository/authentication/auth_repository.dart';
import '../../../service_locator.dart';
import '../../../utils/usecase/usecase.dart';

class SignupUseCase implements UseCase<Either, CreateUserReq> {

  @override
  Future<Either> call({CreateUserReq ? params}) {
    return sl<AuthRepository>().signup(params!);
  }
}
