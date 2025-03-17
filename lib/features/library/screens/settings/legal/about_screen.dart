import 'package:flutter/material.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import 'package:url_launcher/url_launcher.dart'; // Импортируем url_launcher
import '../../../../../common/widgets/app_bar/app_bar.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: Text('About', style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeXl)),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cast, size: 22),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildAboutInfo()),
        ],
      ),
    );
  }

  Widget _buildAboutInfo() {
    final List<Map<String, String>> libraries = [
      {
        'name': 'RxAndroid',
        'company': '© Netflix Inc. — Apache License 2.0',
        'link': 'https://github.com/ReactiveX/RxAndroid'
      },
      {
        'name': 'Universal Image Loader',
        'company': '© Sergey Tarasevich — Apache License 2.0',
        'link': 'https://github.com/nostra13/Android-Universal-Image-Loader'
      },
      {
        'name': 'Jackson JSON',
        'company': '© FasterXML LLC — Apache License 2.0',
        'link': 'https://github.com/FasterXML/jackson'
      },
      {
        'name': 'Dagger',
        'company': '© Square Inc. — Apache License 2.0',
        'link': 'https://github.com/google/dagger'
      },
      {
        'name': 'OkHttp',
        'company': '© Square Inc. — Apache License 2.0',
        'link': 'https://square.github.io/okhttp/'
      },
      {
        'name': 'ViewPageIndicator',
        'company': '© jake Wharton — Apache License 2.0',
        'link': 'https://github.com/rollbar/rollbar-android'
      },
      {
        'name': 'libvorbis, libogg',
        'company': '© Xiph Foundation',
        'link': 'https://github.com/s0uthwest/libvorbis'
      },
      {
        'name': 'loboggz',
        'company': '© CSIRO Australia',
        'link': 'https://github.com/ogozu/loboggz'
      },
      {
        'name': 'Guava',
        'company': '© Google Inc. — Apache License 2.0',
        'link': 'https://github.com/google/guava'
      },
      {
        'name': 'SlidingUpPanelView',
        'company': '© Umano — Apache License 2.0',
        'link': 'https://github.com/Yalantis/SlidingUpPanel'
      },
      {
        'name': 'UndoBar',
        'company': '© Liao Kai — Apache License 2.0',
        'link': 'https://github.com/undo-bar/UndoBar'
      },
      {
        'name': 'uCrop',
        'company': '© Yalantis — Apache License 2.0',
        'link': 'https://github.com/Yalantis/uCrop'
      },
      {
        'name': 'FacebookAndroidSDK',
        'company': '© Facebook Inc. — Apache License 2.0',
        'link': 'https://github.com/facebook/facebook-android-sdk'
      },
      {
        'name': 'Rebound',
        'company': '© Facebook Inc. — BSD License 2.0',
        'link': 'https://github.com/facebook/Rebound'
      },
      {
        'name': 'AOSP',
        'company': 'This software contains code derived from code developed by the Android Open Source Project',
        'link': 'https://android.googlesource.com/platform/packages/apps/Settings/'
      },
    ];

    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: ListView.builder(
        itemCount: libraries.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => _launchURL(libraries[index]['link']!),
            splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
            highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(libraries[index]['name']!, style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                  const SizedBox(height: 8),
                  Text(libraries[index]['company']!, style: TextStyle(color: AppColors.grey, fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.w400, letterSpacing: -0.5)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
