import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

void showRestrictionApplyDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        elevation: 4,
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.youngNight : AppColors.lightBackground,
        titlePadding: const EdgeInsets.all(0),
        actionsPadding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
        contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 16),
        title: Stack(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 14, bottom: 12),
              child: Text('Restrictions apply', style: TextStyle(fontSize: AppSizes.fontSizeMd)),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Subscription may be cancelled at any time in the Google Play Subscription Center. All prices include applicable local sales taxes.',
              style: TextStyle(fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.w200, height: 1.5),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 35, bottom: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: AppSizes.fontSizeSm),
                    children: [
                      const TextSpan(text: 'Artist Pro '),
                      TextSpan(
                        text: 'Terms of Use',
                        style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold, decoration: TextDecoration.none),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          launchUrl(Uri.parse('https://inputstudios.vercel.app/ru-ru/terms-of-use'));
                        },
                      ),
                      const TextSpan(text: ' & '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold, decoration: TextDecoration.none),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          launchUrl(Uri.parse('https://inputstudios.vercel.app/ru-ru/privacy'));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
