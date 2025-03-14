import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:maestro/common/widgets/buttons/basic_app_button.dart';
import 'package:maestro/features/authentication/screens/signin_screen.dart';
import 'package:maestro/features/authentication/screens/signup_screen.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../common/widgets/buttons/app_button.dart';
import '../../../utils/constants/app_images.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../generated/l10n/l10n.dart';

class SignUpOrSignInScreen extends StatelessWidget {
  const SignUpOrSignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BasicAppBar(),
          Align(
            alignment: Alignment.topRight,
            child: SvgPicture.asset(AppVectors.topPattern),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SvgPicture.asset(AppVectors.bottomPattern),
          ),
          Align(alignment: Alignment.bottomLeft, child: Image.asset(AppImages.authBg)),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: 0.7,
                    child: Image.asset(AppImages.logo),
                  ),
                  const SizedBox(height: 55),
                  Text(
                    S.of(context).enjoy,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeXl),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 21),
                  Text(
                    S.of(context).enjoyTitleSignUpSignIn,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: AppSizes.fontSizeSm, color: context.isDarkMode ? AppColors.grey : AppColors.darkerGrey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: BasicAppButton(
                          callback: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => const SignUpScreen(),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          title: S.of(context).register,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 1,
                        child: AppButton(
                          callback: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => const SignInScreen(),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          title: S.of(context).signIn,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
