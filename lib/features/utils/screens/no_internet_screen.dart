import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/helpers/helper_functions.dart';

class NoInternetScreen extends StatefulWidget {
  final VoidCallback onRetry;

  const NoInternetScreen({super.key, required this.onRetry});

  @override
  NoInternetScreenState createState() => NoInternetScreenState();
}

class NoInternetScreenState extends State<NoInternetScreen> {
  bool _isLoading = false;

  void _handleRetry() {
    setState(() {
      _isLoading = true;
    });

    Timer(const Duration(milliseconds: 200), () {
      setState(() {
        _isLoading = false;
      });

      widget.onRetry();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = HelperFunctions.isDarkMode(context);
    final textColor = isDarkMode ? AppColors.white : AppColors.black;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.backgroundColor : AppColors.white,
      body: Center(
        child: _isLoading ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(textColor)) :
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text('No internet connection', textAlign: TextAlign.center, style: TextStyle(fontSize: 17, color: textColor)),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Couldn\'t download content, maybe your \nconnection is down? Pull to try again.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: textColor.withAlpha((0.7 * 255).toInt())),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                foregroundColor: AppColors.black,
                backgroundColor: context.isDarkMode ? AppColors.white : AppColors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                side: BorderSide.none,
                elevation: 4,
                shadowColor: AppColors.black.withAlpha((0.3 * 255).toInt()),
              ),
              onPressed: _handleRetry,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text('Try again', style: TextStyle(color: context.isDarkMode ? AppColors.black : AppColors.white, fontSize: AppSizes.fontSizeMd)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
