import 'package:get_it/get_it.dart';
import 'package:maestro/data/models/authentication/signin_user_req.dart';
import 'package:maestro/data/repository/authentication/auth_repository_impl.dart';
import 'package:maestro/data/sources/authentication/auth_firebase_service.dart';
import 'package:maestro/domain/repository/authentication/authentication.dart';
import 'package:maestro/domain/usecases/authentication/signup.dart';

import 'domain/usecases/authentication/signin.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {

  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());

  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());

  sl.registerSingleton<SignupUseCase>(SignupUseCase());

  sl.registerSingleton<SigninUseCase>(SigninUseCase());
}
