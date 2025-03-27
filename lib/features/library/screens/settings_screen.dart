import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:maestro/common/widgets/app_bar/app_bar.dart';
import 'package:maestro/features/library/screens/library/your_insights_screen.dart';
import 'package:maestro/features/library/screens/settings/add_widgets_screen.dart';
import 'package:maestro/features/library/screens/settings/advertising_screen.dart';
import 'package:maestro/features/library/screens/settings/analytics_screen.dart';
import 'package:maestro/features/library/screens/settings/communications_screen.dart';
import 'package:maestro/features/library/screens/settings/legal/legal_screen.dart';
import 'package:maestro/features/library/screens/settings/select_language_screen.dart';
import 'package:maestro/features/library/screens/settings/social_settings.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import 'package:maestro/routes/custom_page_route.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../home/screens/home_screen.dart';
import '../../home/screens/upload_tracks_screen.dart';
import '../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../widgets/dialogs/logout_confirmation_dialog.dart';
import 'account_screen.dart';
import 'basic_settings_screen.dart';
import 'inbox_settings_screen.dart';
import 'interface_style_screen.dart';
import 'notification_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  final int initialIndex;

  const SettingsScreen({super.key, required this.initialIndex});

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  late final int selectedIndex;
  File? _selectedFile;

  @override
  void initState() {
    super.initState();
    _getAppInfo();
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

  Future<Map<String, String>> _getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final storageBox = GetStorage();

    String? savedTroubleshootingId = storageBox.read('troubleshootingId');

    if (savedTroubleshootingId == null) {
      var uuid = Uuid();
      String troubleshootingId = uuid.v4();
      storageBox.write('troubleshootingId', troubleshootingId);
      savedTroubleshootingId = troubleshootingId;
    }

    return {
      'appVersion': '2025.03.27-release (${packageInfo.buildNumber})',
      'troubleshootingId': savedTroubleshootingId,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: Text('Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeXl)),
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12),
                _buildProfileOption('Account', Icons.arrow_forward_ios, () {
                  Navigator.push(context, createPageRoute(AccountScreen(initialIndex: widget.initialIndex)));
                }),
                _buildProfileOption('Upload', Icons.arrow_forward_ios, () {
                  Navigator.push(context, createPageRoute(UploadTracksScreen(songName: '', shouldSelectFileImmediately: true, selectedFile: _selectedFile)));
                }),
                _buildProfileOption('Your insights', Icons.arrow_forward_ios, () {
                  Navigator.push(context, createPageRoute(YourInsightsScreen(initialIndex: widget.initialIndex)));
                }),
                _buildProfileOption('Basic settings', Icons.arrow_forward_ios, () {
                  Navigator.push(context, createPageRoute(BasicSettingsScreen(initialIndex: widget.initialIndex)));
                }),
                _buildProfileOption('Social settings', Icons.arrow_forward_ios, () {
                  Navigator.push(context, createPageRoute(SocialSettings(initialIndex: widget.initialIndex)));
                }),
                _buildProfileOption('Inbox', Icons.arrow_forward_ios, () {
                  Navigator.push(context, createPageRoute(InboxSettingsScreen(initialIndex: widget.initialIndex)));
                }),
                _buildProfileOption('Notifications', Icons.arrow_forward_ios, () {
                  Navigator.push(context, createPageRoute(NotificationSettingsScreen(initialIndex: widget.initialIndex)));
                }),
                _buildProfileOption('Add widgets', Icons.arrow_forward_ios, () {
                  Navigator.push(context, createPageRoute(AddWidgetsScreen(initialIndex: widget.initialIndex)));
                }),
                SizedBox(height: 14),
                _buildProfileOption('Interface style', Icons.arrow_forward_ios, () {
                  Navigator.push(context, createPageRoute(InterfaceStyleScreen()));
                }),
                _buildProfileOption('Languages', Icons.arrow_forward_ios, () {
                  Navigator.push(context, createPageRoute(SelectLanguageScreen(initialIndex: widget.initialIndex)));
                }),
                SizedBox(height: 14),
                _buildProfileOption('Analytics', Icons.arrow_forward_ios, () {
                  Navigator.push(context, createPageRoute(AnalyticsScreen(initialIndex: widget.initialIndex)));
                }),
                _buildProfileOption('Communications', Icons.arrow_forward_ios, () {
                  Navigator.push(context, createPageRoute(CommunicationsScreen(initialIndex: widget.initialIndex)));
                }),
                _buildProfileOption('Advertising', Icons.arrow_forward_ios, () {
                  Navigator.push(context, createPageRoute(AdvertisingScreen(initialIndex: widget.initialIndex)));
                }),
                SizedBox(height: 14),
                _buildMoreOption('Support', Icons.arrow_forward_ios, () {
                  _launchURL('https://inputstudios.vercel.app/ru-ru/terms-of-use');
                }),
                _buildMoreOption('Legal', Icons.arrow_forward_ios, () {
                  Navigator.push(context, createPageRoute(LegalScreen(initialIndex: widget.initialIndex)));
                }),
                SizedBox(height: 8),
                _buildSectionSignOut(),
                FutureBuilder<Map<String, String>>(
                  future: _getAppInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)));
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      var data = snapshot.data!;
                      return _buildVersionApp(data['appVersion']!, data['troubleshootingId']!);
                    } else {
                      return Text('No data');
                    }
                  },
                ),
                SizedBox(height: 70),
              ],
            ),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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

  Widget _buildMoreOption(String text, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Row(
          children: [
            Text(text, style: const TextStyle(fontSize: AppSizes.fontSizeMd)),
            const Spacer(),
            Icon(icon, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionSignOut() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 8),
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

  Widget _buildVersionApp(String appVersion, String troubleshootingId) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('App version $appVersion', style: TextStyle(fontSize: AppSizes.fontSizeSm), textAlign: TextAlign.center),
          SizedBox(height: 4),
          Text('Troubleshooting id $troubleshootingId', style: TextStyle(fontSize: AppSizes.fontSizeSm), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
