import 'package:flutter/material.dart';
import 'app.dart';

/// Entry point of Flutter App
Future<void> main() async {
  /// Initialize application dependencies and services
  await initApp();

  /// Run the application
  runApp(const App());
}