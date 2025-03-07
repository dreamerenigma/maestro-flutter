import 'package:flutter/material.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
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
    final List<String> library = [
      'Welcome to the About screen.',
      'Here is some information about the app.',
      'This app is designed to provide users with various features.',
      'You can explore more settings in the menu.',
      'Feel free to customize your preferences.',
      'Contact us if you have any questions.',
      'Privacy policy is available for review.',
      'Terms and conditions apply.',
      'The app is constantly being updated.',
      'Stay tuned for new features.',
      'We value your feedback and suggestions.',
      'Our team works hard to improve the app.',
      'Thank you for using our application.',
      'We hope you enjoy the experience.',
      'If you have any issues, reach out to support.',
    ];

    final List<String> libraryCompany = [
      '@ Welcome — to the About screen.',
      '@ Here — is some information about the app.',
      '@ This — app is designed to provide users with various features.',
      '@ You — can explore more settings in the menu.',
      '@ Feel — free to customize your preferences.',
      '@ Contact — us if you have any questions.',
      '@ Privacy — policy is available for review.',
      '@ Terms — and conditions apply.',
      '@ The — app is constantly being updated.',
      '@ Stay — tuned for new features.',
      '@ We — value your feedback and suggestions.',
      '@ Our — team works hard to improve the app.',
      '@ Thank — you for using our application.',
      '@ We — hope you enjoy the experience.',
      '@ If — you have any issues, reach out to support.',
    ];

    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: ListView.builder(
        itemCount: library.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {},
            splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
            highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(library[index], style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                  const SizedBox(height: 8),
                  Text(libraryCompany[index], style: TextStyle(color: AppColors.grey, fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.w400, letterSpacing: -0.5)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

