import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maestro/core/configs/assets/app_vectors.dart';
import 'package:maestro/presentation/authentication/pages/signup_or_signin.dart';
import 'package:maestro/presentation/choose_mode/bloc/theme_cubit.dart';
import '../../../common/widgets/buttons/basic_app_button.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/assets/app_sizes.dart';
import '../../../core/configs/themes/app_colors.dart';

class ChooseModePage extends StatelessWidget {
  const ChooseModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      AppImages.chooseModeBg,
                    ),
                  ),
                ),
              ),

              Container(
                color: AppColors.black.withOpacity(0.15),
              ),

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
                    const Text('Choose Mode',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: AppSizes.fontSizeLg,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.read<ThemeCubit>().updateTheme(ThemeMode.dark);
                              },
                              child: ClipOval(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF30393C).withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: SvgPicture.asset(
                                      AppVectors.moon,
                                      colorFilter: ColorFilter.mode(
                                        themeMode == ThemeMode.dark ? AppColors.blue : Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                      fit: BoxFit.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w500, fontSize: AppSizes.fontSizeMd, color: AppColors.grey)),
                          ],
                        ),
                        const SizedBox(width: 40),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.read<ThemeCubit>().updateTheme(ThemeMode.light);
                              },
                              child: ClipOval(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF30393C).withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: SvgPicture.asset(
                                      AppVectors.sun,
                                      colorFilter: ColorFilter.mode(
                                        themeMode == ThemeMode.light ? AppColors.yellow : Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                      fit: BoxFit.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text('Light Mode', style: TextStyle(fontWeight: FontWeight.w500, fontSize: AppSizes.fontSizeMd, color: AppColors.grey)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    const SizedBox(width: 20),
                    BasicAppButton(
                      callback: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => const SignupOrSigninPage(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      title: 'Continue',
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
