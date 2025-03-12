import 'package:dartz/dartz.dart';
import 'package:maestro/features/authentication/models/create_user_req.dart';
import '../../../domain/repository/authentication/auth_repository.dart';
import '../../../features/authentication/models/signin_user_req.dart';
import '../../../service_locator.dart';
import '../../services/authentication/auth_firebase_service.dart';

class AuthRepositoryImpl extends AuthRepository {

  @override
  Future<Either> signin(SignInUserReq signinUserReq) async {
    return await sl<AuthFirebaseService>().signIn(signinUserReq);
  }

  @override
  Future<Either> signup(CreateUserReq createUserReq) async {
    return await sl<AuthFirebaseService>().signUp(createUserReq);
  }
}
