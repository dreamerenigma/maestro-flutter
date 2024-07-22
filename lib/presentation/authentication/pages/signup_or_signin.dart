import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:maestro/common/widgets/buttons/basic_app_button.dart';
import 'package:maestro/presentation/authentication/pages/signin.dart';
import 'package:maestro/presentation/authentication/pages/signup.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/assets/app_sizes.dart';
import '../../../core/configs/assets/app_vectors.dart';
import '../../../core/configs/themes/app_colors.dart';

class SignupOrSigninPage extends StatelessWidget {
  const SignupOrSigninPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BasicAppBar(),
          Align(
            alignment: Alignment.topRight,
            child: SvgPicture.asset(
              AppVectors.topPattern
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SvgPicture.asset(
                AppVectors.bottomPattern
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(AppImages.authBg)
          ),
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
                  const Text(
                    'Enjoy Listening To Music',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeGg),
                  ),
                  const SizedBox(height: 21),
                  const Text(
                    'Maestro is a proprietary Russian audio streaming and media services provider',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: AppSizes.fontSizeSm, color: AppColors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: BasicAppButton(
                          callback: () {
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SignupPages()));
                          },
                          title: 'Register',
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SigninPages()));
                          },
                          child: Text('Sign in',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: AppSizes.fontSizeMd,
                              color: context.isDarkMode ? AppColors.white : AppColors.black,
                            ),
                          ),
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
