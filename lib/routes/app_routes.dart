import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:maestro/routes/routes.dart';
import '../features/authentication/screens/signin_screen.dart';
import '../features/authentication/screens/signup_or_signin_screen.dart';
import '../features/splash/screens/splash_screen.dart';

class AppRoutes {
  static final pages = [
    GetPage(name: MaestroRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: MaestroRoutes.logout, page: () => const SignInScreen()),
    GetPage(name: MaestroRoutes.signInOrSignUp, page: () => const SignUpOrSignInScreen()),
  ];
}
