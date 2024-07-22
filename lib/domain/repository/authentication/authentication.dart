import 'package:dartz/dartz.dart';
import 'package:maestro/data/models/authentication/create_user_req.dart';

import '../../../data/models/authentication/signin_user_req.dart';

abstract class AuthRepository {

  Future<Either> signup(CreateUserReq createUserReq);

  Future<Either> signin(SigninUserReq signinUserReq);
}
