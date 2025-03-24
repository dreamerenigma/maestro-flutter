import 'dart:ui';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maestro/utils/constants/app_vectors.dart';
import '../../../common/widgets/buttons/basic_app_button.dart';
import '../../../utils/constants/app_images.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../generated/l10n/l10n.dart';
import '../../authentication/screens/signup_or_signin_screen.dart';
import '../bloc/theme_cubit.dart';

class ChooseModeScreen extends StatelessWidget {
  const ChooseModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Brightness systemBrightness = PlatformDispatcher.instance.platformBrightness;
    final initialThemeMode = systemBrightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
    context.read<ThemeCubit>().updateTheme(initialThemeMode);

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
                    image: AssetImage(AppImages.chooseModeBg),
                  ),
                ),
              ),
              Container(
                color: AppColors.black.withAlpha((0.15 * 255).toInt()),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
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
                    Text(S.of(context).chooseMode, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.white, fontSize: AppSizes.fontSizeLg)),
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
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF30393C).withAlpha((0.5 * 255).toInt()),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: SvgPicture.asset(
                                      AppVectors.moon,
                                      colorFilter: ColorFilter.mode(
                                        themeMode == ThemeMode.dark ? AppColors.blue : AppColors.white,
                                        BlendMode.srcIn,
                                      ),
                                      fit: BoxFit.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(S.of(context).dark, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: AppSizes.fontSizeMd, color: AppColors.grey)),
                          ],
                        ),
                        const SizedBox(width: 35),
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
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF30393C).withAlpha((0.5 * 255).toInt()),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: SvgPicture.asset(
                                      AppVectors.sun,
                                      colorFilter: ColorFilter.mode(
                                        themeMode == ThemeMode.light ? AppColors.yellow : AppColors.white,
                                        BlendMode.srcIn,
                                      ),
                                      fit: BoxFit.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(S.of(context).light, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: AppSizes.fontSizeMd, color: AppColors.grey)),
                          ],
                        ),
                        const SizedBox(width: 35),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.read<ThemeCubit>().updateTheme(ThemeMode.system);
                              },
                              child: ClipOval(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF30393C).withAlpha((0.5 * 255).toInt()),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      FluentIcons.settings_48_regular,
                                      color: themeMode == ThemeMode.system ? AppColors.buttonPrimary : AppColors.white,
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(S.of(context).system, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: AppSizes.fontSizeMd, color: AppColors.grey)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    BasicAppButton(
                      callback: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => const SignUpOrSignInScreen(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      title: S.of(context).continueButton,
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