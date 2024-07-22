import 'package:dartz/dartz.dart';
import 'package:maestro/data/models/authentication/signin_user_req.dart';
import 'package:maestro/domain/repository/authentication/authentication.dart';
import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';

class SigninUseCase implements UseCase<Either, SigninUserReq> {

  @override
  Future<Either> call({SigninUserReq ? params}) {
    return sl<AuthRepository>().signin(params!);
  }
}
