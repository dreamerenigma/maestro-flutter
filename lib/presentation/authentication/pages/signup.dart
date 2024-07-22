import 'package:flutter/material.dart';
import 'package:maestro/common/widgets/app_bar/app_bar.dart';
import 'package:maestro/common/widgets/buttons/basic_app_button.dart';
import 'package:maestro/data/models/authentication/create_user_req.dart';
import 'package:maestro/domain/usecases/authentication/signup.dart';
import 'package:maestro/presentation/authentication/pages/signin.dart';
import 'package:maestro/presentation/root/pages/root.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/assets/app_sizes.dart';
import '../../../core/configs/themes/app_colors.dart';
import '../../../service_locator.dart';

class SignupPages extends StatelessWidget {
  SignupPages({super.key});

  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _signinText(context),
      appBar: BasicAppBar(
        title: Image.asset(
          AppImages.logo,
          height: 160,
          width: 160,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _registerText(),
            const SizedBox(height: 50),
            _fullNameField(context),
            const SizedBox(height: 20),
            _emailField(context),
            const SizedBox(height: 20),
            _passwordField(context),
            const SizedBox(height: 20),
            BasicAppButton(
              callback: () async {
                var result = await sl<SignupUseCase>().call(
                  params: CreateUserReq(
                    fullName: _fullName.text.toString(),
                    email: _email.text.toString(),
                    password: _password.text.toString(),
                  ),
                );
                result.fold(
                  (l) {
                    var snackbar = SnackBar(content: Text(l), behavior: SnackBarBehavior.floating);
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  },
                  (r) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) => const RootPage()),
                        (route) => false,
                    );
                  },
                );
              },
              title: 'Create Account',
            ),
          ],
        ),
      ),
    );
  }

  Widget _registerText() {
    return const Text(
      'Register',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeGg));
  }

  Widget _fullNameField(BuildContext context) {
    return TextSelectionTheme(
      data: TextSelectionThemeData(
        cursorColor: Colors.blue,
        selectionColor: Colors.blue.withOpacity(0.3),
        selectionHandleColor: Colors.blue,
      ),
      child: TextField(
        controller: _fullName,
        cursorColor: Colors.blue,
        decoration: const InputDecoration(
          hintText: 'Full Name',
        ).applyDefaults(
          Theme.of(context).inputDecorationTheme,
        ),
      ),
    );
  }

  Widget _emailField(BuildContext context) {
    return TextSelectionTheme(
      data: TextSelectionThemeData(
        cursorColor: Colors.blue,
        selectionColor: Colors.blue.withOpacity(0.3),
        selectionHandleColor: Colors.blue,
      ),
      child: TextField(
        controller: _email,
        cursorColor: Colors.blue,
        decoration: const InputDecoration(
          hintText: 'Enter Email',
        ).applyDefaults(
          Theme.of(context).inputDecorationTheme,
        ),
      ),
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextSelectionTheme(
      data: TextSelectionThemeData(
        cursorColor: Colors.blue,
        selectionColor: Colors.blue.withOpacity(0.3),
        selectionHandleColor: Colors.blue,
      ),
      child: TextField(
        controller: _password,
        cursorColor: Colors.blue,
        decoration: const InputDecoration(
          hintText: 'Password',
        ).applyDefaults(
          Theme.of(context).inputDecorationTheme,
        ),
      ),
    );
  }

  Widget _signinText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Do you have an account?',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: AppSizes.fontSizeSm,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SigninPages()));
            },
            child: const Text('Sign In', style: TextStyle(color: AppColors.blue)),
          ),
        ],
      ),
    );
  }
}
