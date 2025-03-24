import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maestro/utils/constants/app_images.dart';
import '../../home/screens/home_screen.dart';
import '../../intro/screens/get_started_screen.dart';
import '../../song_player/widgets/mini_player/mini_player_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startSplashScreen();
  }

  void _startSplashScreen() async {
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      final user = FirebaseAuth.instance.currentUser;
      final nextPage = user != null ? const HomeScreen() : const GetStartedScreen();

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => nextPage,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MiniPlayerManager(
      hideMiniPlayerOnSplash: true,
      child: Scaffold(
        body: Center(
          child: Image.asset(
            AppImages.logoSplash,
            width: 150.0,
            height: 150.0,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
