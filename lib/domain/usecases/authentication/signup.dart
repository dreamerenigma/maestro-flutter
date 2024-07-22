import 'package:dartz/dartz.dart';
import 'package:maestro/data/models/authentication/create_user_req.dart';
import 'package:maestro/domain/repository/authentication/authentication.dart';
import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';

class SignupUseCase implements UseCase<Either, CreateUserReq> {

  @override
  Future<Either> call({CreateUserReq ? params}) {
    return sl<AuthRepository>().signup(params!);
  }
}
