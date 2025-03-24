import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:maestro/common/widgets/app_bar/app_bar.dart';
import 'package:maestro/common/widgets/buttons/basic_app_button.dart';
import 'package:maestro/features/authentication/screens/signin_screen.dart';
import 'package:maestro/routes/custom_page_route.dart';
import '../../../data/services/authentication/auth_firebase_service.dart';
import '../../../utils/constants/app_images.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../generated/l10n/l10n.dart';
import '../../home/screens/home_screen.dart';
import '../../information/screens/privacy_policy_screen.dart';
import '../../information/screens/terms_of_use_screen.dart';
import 'create_info_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final AuthFirebaseService _authService = AuthFirebaseServiceImpl();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _isLoading = false;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _updateFormState() {
    if (_formKey.currentState != null) {
      _formKey.currentState!.validate();
    }
  }

  void _showError(BuildContext context, String message) {
    Get.snackbar('Error', message);
  }

  void _showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: AppColors.green));
    if (message == S.of(context).googleSignUpSuccess || message == S.of(context).appleSignInSuccess) {
      Navigator.pushReplacement(context, createPageRoute(HomeScreen()));
    }
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildRegisterText(),
                        const SizedBox(height: 30),
                        _buildFullNameField(context),
                        const SizedBox(height: 20),
                        _buildEmailField(context),
                        const SizedBox(height: 20),
                        _buildPasswordField(context),
                        const SizedBox(height: 20),
                        BasicAppButton(
                          callback: () async {
                            if (_formKey.currentState!.validate()) {
                              await Navigator.push(
                                context,
                                createPageRoute(CreateInfoScreen(fullNameController: _fullName, emailController: _email, passwordController: _password)),
                              );
                            }
                          },
                          title: S.of(context).next,
                        ),
                        _buildPrivacyText(context),
                        const SizedBox(height: 20),
                        _buildSocialButtons(),
                      ],
                    ),
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
            child: _buildSigInText(context),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterText() {
    return Text(S.of(context).register, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeXl));
  }

  Widget _buildFullNameField(BuildContext context) {
    return TextSelectionTheme(
      data: TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionColor: AppColors.primary.withAlpha((0.3 * 255).toInt()),
        selectionHandleColor: AppColors.primary,
      ),
      child: SizedBox(
        height: 70,
        child: TextFormField(
          controller: _fullName,
          cursorColor: AppColors.primary,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: S.of(context).fullName,
            contentPadding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          ).applyDefaults(
            Theme.of(context).inputDecorationTheme,
          ),
          onChanged: (value) {
            _updateFormState();
          },
          style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w400),
        ),
      ),
    );
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
        child: TextFormField(
          controller: _email,
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            hintText: S.of(context).enterEmail,
            contentPadding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          ).applyDefaults(
            Theme.of(context).inputDecorationTheme,
          ),
          onChanged: (value) {
            _updateFormState();
          },
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
        child: TextFormField(
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
          onChanged: (value) {
            _updateFormState();
          },
          style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  Widget _buildPrivacyText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: S.of(context).nextYouAgree,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: AppSizes.fontSizeSm,
                  color: context.isDarkMode ? AppColors.white : AppColors.black
              ),
              children: [
                TextSpan(
                  text: S.of(context).termsOfUse,
                  style: const TextStyle(
                    color: AppColors.blue,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {
                    Navigator.pushReplacement(context, createPageRoute(TermsOfUseScreen()));
                  },
                ),
                TextSpan(
                  text: S.of(context).dataSendingAdvertising,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: AppSizes.fontSizeSm,
                      color: context.isDarkMode ? AppColors.white : AppColors.black
                  ),
                ),
                TextSpan(
                  text: S.of(context).privacyPolicy,
                  style: const TextStyle(
                    color: AppColors.blue,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushReplacement(context, createPageRoute(PrivacyPolicyScreen()));
                    },
                ),
              ],
            ),
          ),
        ],
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

            final result = await _authService.googleSignUp();
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
        child: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Center(child: child),
        ),
      ),
    );
  }

  Widget _buildSigInText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(S.of(context).youHaveAccount, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: AppSizes.fontSizeSm)),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(context, createPageRoute(SignInScreen()));
          },
          style: TextButton.styleFrom(padding: EdgeInsets.only(left: 8, right: 8), foregroundColor: AppColors.blue.withAlpha((0.1 * 255).toInt())),
          child: Text(S.of(context).signIn, style: const TextStyle(color: AppColors.blue, fontSize: AppSizes.fontSizeSm)),
        ),
      ],
    );
  }
}
