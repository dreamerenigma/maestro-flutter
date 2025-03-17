import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestro/common/widgets/app_bar/app_bar.dart';
import 'package:maestro/routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../home/screens/home_screen.dart';
import '../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../widgets/dialogs/logout_confirmation_dialog.dart';
import 'delete_account_screen.dart';

class AccountScreen extends StatefulWidget {
  final int initialIndex;

  const AccountScreen({super.key, required this.initialIndex});

  @override
  State<AccountScreen> createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen> {
  late final int selectedIndex;
  late final Function(int) onItemTapped;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    _getUserEmail();
  }

  Future<void> _getUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: const Text('Account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeBg)),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cast, size: 22),
          ),
        ],
      ),
      body: MiniPlayerManager(
        hideMiniPlayerOnSplash: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10, left: 16),
              child: Text('Email address', style: TextStyle(fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(userEmail ?? 'No email found', style: TextStyle(fontSize: AppSizes.fontSizeSm)),
            ),
            _buildSectionSignOut(),
            _buildSectionDelete('Delete account', Icons.arrow_forward_ios, () {
              Navigator.push(context, createPageRoute(DeleteAccountScreen(initialIndex: widget.initialIndex)));
            }),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: (index) {
          Navigator.pushReplacement(context, createPageRoute(HomeScreen(initialIndex: index)));
        },
      ),
    );
  }

  Widget _buildSectionSignOut() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
      child: ElevatedButton(
        onPressed: () {
          showLogoutConfirmationDialog(context);
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          backgroundColor: context.isDarkMode ? AppColors.darkGrey : AppColors.grey,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          side: BorderSide.none,
          elevation: 4,
          shadowColor: AppColors.black.withAlpha((0.3 * 255).toInt()),
        ),
        child: Center(
          child: Text('Sign out',
            style: TextStyle(color: context.isDarkMode ? AppColors.white : AppColors.black, fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionDelete(String text, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Row(
          children: [
            Text(text, style: const TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w400)),
            const Spacer(),
            Icon(icon, size: AppSizes.iconSm),
          ],
        ),
      ),
    );
  }
}
