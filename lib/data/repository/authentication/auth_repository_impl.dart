import 'package:dartz/dartz.dart';
import 'package:maestro/data/models/authentication/create_user_req.dart';
import 'package:maestro/data/sources/authentication/auth_firebase_service.dart';
import '../../../domain/repository/authentication/authentication.dart';
import '../../../service_locator.dart';
import '../../models/authentication/signin_user_req.dart';

class AuthRepositoryImpl extends AuthRepository {

  @override
  Future<Either> signin(SigninUserReq signinUserReq) async {
    return await sl<AuthFirebaseService>().signin(signinUserReq);
  }

  @override
  Future<Either> signup(CreateUserReq createUserReq) async {
    return await sl<AuthFirebaseService>().signup(createUserReq);
  }
}
