import 'package:flutter/material.dart';
import 'package:maestro/common/widgets/buttons/basic_app_button.dart';
import 'package:maestro/utils/constants/app_images.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../generated/l10n/l10n.dart';
import '../../choose_mode/screens/choose_mode_screen.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  AppImages.introBg,
                ),
              ),
            ),
          ),
          Container(color: AppColors.black.withAlpha((0.15 * 255).toInt())),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Transform.scale(
                    scale: 0.8,
                    child: Image.asset(AppImages.logo),
                  ),
                ),
                const Spacer(),
                Center(
                  child: Text(
                    S.of(context).enjoy,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.white, fontSize: AppSizes.fontSizeLg),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 21),
                Center(
                  child: Text(
                    S.of(context).enjoyTitle,
                    style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.grey, fontSize: AppSizes.fontSizeSm),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                BasicAppButton(
                  callback: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                        const ChooseModeScreen(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  title: S.of(context).getStarted,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
