import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import 'animated_snackbar.dart';

class Dialogs {
  static void showSnackBar(BuildContext context, String msg, {
    double fontSize = AppSizes.fontSizeSm
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: fontSize),
        ),
        backgroundColor: AppColors.blue.withAlpha((0.8 * 255).toInt()),
        behavior: SnackBarBehavior.fixed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  static void showSnackBarMargin(BuildContext context, String msg, {
    EdgeInsetsGeometry margin = const EdgeInsets.only(),
    double fontSize = AppSizes.fontSizeSm
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: fontSize),
        ),
        backgroundColor: AppColors.blue.withAlpha((0.8 * 255).toInt()),
        behavior: SnackBarBehavior.floating,
        margin: margin,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  static Future<void> showProgressBar(BuildContext context, {Color color = AppColors.primary}) {
  // Показываем диалог
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        child: Center(
          child: SizedBox(
            width: 40.0,
            height: 40.0,
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(color)),
          ),
        ),
      );
    },
  );

  // Закрытие диалога через 2 секунды
  Future.delayed(const Duration(seconds: 2), () {
    if (Navigator.canPop(context)) {
      Navigator.pop(context); // Закрываем диалог
    }
  });

  // Возвращаем Future, которое завершится после того, как диалог закроется
  return Future.delayed(const Duration(seconds: 2));
}

  static Future<void> showProgressBarDialog(BuildContext context, {String? title, required String message}) async {
    bool hasTitle = title != null && title.isNotEmpty;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.youngNight : AppColors.lightGrey,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          contentPadding: hasTitle ? const EdgeInsets.symmetric(horizontal: 16, vertical: 20) : const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300, maxHeight: 200),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasTitle) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(title, style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.normal), textAlign: TextAlign.left),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
                      ),
                    ),
                    const SizedBox(width: 25),
                    Expanded(child: Text(message, style: TextStyle(fontSize: AppSizes.fontSizeMd), overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void hideProgressBar(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}

class CustomIconSnackBar {
  static bool _isSnackBarVisible = false;

  static Future<void> showAnimatedSnackBar(
      BuildContext context,
      String message,
      {Widget? icon, Color? iconColor, Color? backgroundColor,
      }) async {
    if (_isSnackBarVisible) return;

    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry;

    GlobalKey<AnimatedSnackBarState> snackBarKey = GlobalKey<AnimatedSnackBarState>();

    overlayEntry = OverlayEntry(
      builder: (context) {

        return Positioned(
          left: 16,
          right: 16,
          bottom: 20,
          child: AnimatedSnackBar(
            key: snackBarKey,
            message: message,
            icon: icon,
            iconColor: iconColor,
            backgroundColor: backgroundColor,
          ),
        );
      },
    );

    overlayState.insert(overlayEntry);
    _isSnackBarVisible = true;

    await Future.delayed(const Duration(seconds: 4));

    if (snackBarKey.currentState != null) {
      await snackBarKey.currentState!.hideSnackBar();
    }

    overlayEntry.remove();
    _isSnackBarVisible = false;
  }
}
