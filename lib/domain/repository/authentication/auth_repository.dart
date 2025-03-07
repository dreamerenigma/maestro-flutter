import 'package:dartz/dartz.dart';
import 'package:maestro/features/authentication/models/create_user_req.dart';
import '../../../features/authentication/models/signin_user_req.dart';

abstract class AuthRepository {
  Future<Either> signup(CreateUserReq createUserReq);
  Future<Either> signin(SignInUserReq signinUserReq);
}
