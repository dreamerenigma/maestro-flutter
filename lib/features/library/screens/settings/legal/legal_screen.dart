import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../common/widgets/app_bar/app_bar.dart';
import '../../../../../routes/custom_page_route.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../home/screens/home_screen.dart';
import '../../../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../../../../utils/widgets/no_glow_scroll_behavior.dart';
import 'about_screen.dart';

class LegalScreen extends StatefulWidget {
  final int initialIndex;

  const LegalScreen({super.key, required this.initialIndex});

  @override
  State<LegalScreen> createState() => _LegalScreenState();
}

class _LegalScreenState extends State<LegalScreen> {
  late final int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: Text('Legal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeXl)),
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
        child: ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileOption('Copyright information', Icons.arrow_forward_ios, () {
                Navigator.push(context, createPageRoute(AboutScreen()));
              }),
              _buildProfileOption('Terms of use', Icons.arrow_forward_ios, () {
                _launchURL('https://inputstudios.vercel.app/ru-ru/terms-of-use');
              }),
              _buildProfileOption('Privacy Policy', Icons.arrow_forward_ios, () {
                _launchURL('https://inputstudios.vercel.app/ru-ru/privacy');
              }),
              _buildProfileOption('Imprint', Icons.arrow_forward_ios, () {
                _launchURL('https://inputstudios.vercel.app/ru-ru/imprint');
              }),
            ],
          ),
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

  Widget _buildProfileOption(String text, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Row(
          children: [
            Text(text, style: const TextStyle(fontSize: 17)),
            const Spacer(),
            Icon(icon, size: 20),
          ],
        ),
      ),
    );
  }
}
