import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestro/features/library/widgets/dialogs/delete_account.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../home/screens/home_screen.dart';
import '../../home/widgets/nav_bar/bottom_nav_bar.dart';

class DeleteAccountScreen extends StatefulWidget {
  final int initialIndex;

  const DeleteAccountScreen({super.key, required this.initialIndex});

  @override
  State<DeleteAccountScreen> createState() => DeleteAccountScreenState();
}

class DeleteAccountScreenState extends State<DeleteAccountScreen> {
  late final int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: const Text('Delete account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeBg)),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cast, size: 22),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10, left: 16),
            child: Text('This will delete your account and all your \ntracks, comments and stats',
              style: TextStyle(fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.w400),
            ),
          ),
          _buildSectionDeleteAccount(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: (index) {
          Navigator.pushReplacement(context, createPageRoute(HomeScreen(initialIndex: index)));
        },
      ),
    );
  }

  Widget _buildSectionDeleteAccount() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
      child: ElevatedButton(
        onPressed: () {
          showDeleteAccountDialog(context);
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          backgroundColor: AppColors.red.withAlpha((0.6 * 255).toInt()),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          side: BorderSide.none,
          elevation: 4,
          shadowColor: AppColors.black.withAlpha((0.3 * 255).toInt()),
        ),
        child: Center(
          child: Text('Delete account',
            style: TextStyle(color: context.isDarkMode ? AppColors.white : AppColors.black, fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w500), textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
