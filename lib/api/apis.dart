import 'package:flutter/material.dart';
import 'package:maestro/presentation/intro/pages/get_started.dart';

class APIs {
  static Widget redirect(BuildContext context) {
    return FutureBuilder<void>(
      future: delayedNavigation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const GetStartedPage()),
            );
          });
        }
        return Container();
      },
    );
  }

  static Future<void> delayedNavigation() async {
    await Future.delayed(const Duration(seconds: 2));
  }
}