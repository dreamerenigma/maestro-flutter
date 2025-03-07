import 'package:dartz/dartz.dart';
import 'package:maestro/domain/repository/authentication/auth_repository.dart';
import '../../../features/authentication/models/signin_user_req.dart';
import '../../../service_locator.dart';
import '../../../utils/usecase/usecase.dart';

class SigninUseCase implements UseCase<Either, SignInUserReq> {

  @override
  Future<Either> call({SignInUserReq ? params}) {
    return sl<AuthRepository>().signin(params!);
  }
}
