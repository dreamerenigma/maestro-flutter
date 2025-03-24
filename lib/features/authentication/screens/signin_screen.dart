import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:maestro/common/widgets/app_bar/app_bar.dart';
import 'package:maestro/common/widgets/buttons/basic_app_button.dart';
import 'package:maestro/domain/usecases/authentication/signin.dart';
import 'package:maestro/features/authentication/screens/signup_screen.dart';
import '../../../data/services/authentication/auth_firebase_service.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_images.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../service_locator.dart';
import '../../../utils/popups/dialogs.dart';
import '../../home/screens/home_screen.dart';
import '../models/signin_user_req.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  bool _obscureText = true;
  bool _isLoading = false;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final AuthFirebaseService _authService = AuthFirebaseServiceImpl();
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUserAuth();
    });
  }

  void _checkUserAuth() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && mounted) {
      Future.delayed(Duration.zero, () {
        if (mounted) {
          Navigator.pushReplacement(context, createPageRoute(HomeScreen()));
        }
      });
    }
  }

  void _showError(BuildContext context, String message) {
    Get.snackbar('Error', message);
  }

  void _showSuccess(BuildContext context, String message) {
    Navigator.pushReplacement(context, createPageRoute(HomeScreen()));
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(title: Image.asset(AppImages.logo, height: 160, width: 160)),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildRegisterText(),
                      const SizedBox(height: 30),
                      _buildEmailField(context),
                      const SizedBox(height: 20),
                      _buildPasswordField(context),
                      const SizedBox(height: 20),
                      BasicAppButton(
                        callback: () async {
                          var result = await sl<SigninUseCase>().call(
                            params: SignInUserReq(
                              email: _email.text.toString(),
                              password: _password.text.toString(),
                            ),
                          );
                          result.fold(
                            (l) {
                              Dialogs.showSnackBarMargin(context, S.of(context).allFieldsFilled, margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10));
                            },
                            (r) {
                              Dialogs.showSnackBarMargin(context, S.of(context).signInSuccessful, margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10));
                              Navigator.pushAndRemoveUntil(context, createPageRoute(HomeScreen()), (route) => false);
                            },
                          );
                        },
                        title: S.of(context).signIn,
                      ),
                      const SizedBox(height: 20),
                      _buildSocialButtons(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_isLoading)
          Positioned.fill(
            child: Container(
              color: AppColors.black.withAlpha((0.5 * 255).toInt()),
              child: const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary))),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildSignupText(context),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterText() {
    return Text(S.of(context).signIn, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeXl));
  }

  Widget _buildEmailField(BuildContext context) {
    return TextSelectionTheme(
      data: TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionColor: AppColors.primary.withAlpha((0.3 * 255).toInt()),
        selectionHandleColor: AppColors.primary,
      ),
      child: SizedBox(
        height: 70,
        child: TextField(
          controller: _email,
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            hintText: S.of(context).enterEmail,
            contentPadding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          ).applyDefaults(
            Theme.of(context).inputDecorationTheme,
          ),
          style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return TextSelectionTheme(
      data: TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionColor: AppColors.primary.withAlpha((0.3 * 255).toInt()),
        selectionHandleColor: AppColors.primary,
      ),
      child: SizedBox(
        height: 70,
        child: TextField(
          controller: _password,
          obscureText: _obscureText,
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            hintText: S.of(context).password,
            contentPadding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: AppColors.blue,
              ),
              onPressed: _togglePasswordVisibility,
            ),
          ).applyDefaults(
            Theme.of(context).inputDecorationTheme,
          ),
          style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(
          child: SvgPicture.asset(AppVectors.google, width: 24, height: 24),
          onPressed: () async {

            setState(() {
              _isLoading = true;
            });

            final result = await _authService.googleSignIn();

            result.fold(
              (l) {
                _showError(context, l);
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
              (r) {
                _showSuccess(context, r);
              },
            );
          },
        ),
        const SizedBox(width: 20),
        _buildSocialButton(
          child: const Icon(Icons.apple, size: 36, color: AppColors.black),
          onPressed: () async {
            final result = await _authService.appleSignIn();
            result.fold(
              (l) => _showError(context, l),
              (r) => _showSuccess(context, r),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSocialButton({required Widget child, required VoidCallback onPressed}) {
    return Material(
      shape: const CircleBorder(),
      color: context.isDarkMode ? AppColors.white : AppColors.lightGrey,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        splashColor: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
        highlightColor: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
        child: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Center(child: child),
        ),
      ),
    );
  }

  Widget _buildSignupText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(S.of(context).notMember, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: AppSizes.fontSizeSm)),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(context, createPageRoute(SignUpScreen()));
          },
          style: TextButton.styleFrom(padding: EdgeInsets.only(left: 8, right: 8), foregroundColor: AppColors.blue.withAlpha((0.1 * 255).toInt())),
          child: Text(S.of(context).registerNow, style: const TextStyle(color: AppColors.blue, fontSize: AppSizes.fontSizeSm)),
        ),
      ],
    );
  }
}
