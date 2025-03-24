import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../home/screens/home_screen.dart';
import '../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../../utils/screens/internet_aware_screen.dart';
import '../widgets/sections/section_widget.dart';
import '../widgets/switches.dart';
import 'notification_settings_screen.dart';

class InboxSettingsScreen extends StatefulWidget {
  final int initialIndex;

  const InboxSettingsScreen({super.key, required this.initialIndex});

  @override
  State<InboxSettingsScreen> createState() => _InboxSettingsScreenState();
}

class _InboxSettingsScreenState extends State<InboxSettingsScreen> {
  late final int selectedIndex;
  bool _receiveMessageAnyone = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    selectedIndex = widget.initialIndex;
  }

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('receive_message_anyone', _receiveMessageAnyone);
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _receiveMessageAnyone = prefs.getBool('receive_message_anyone') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: const Text('Inbox settings', style: TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.cast, size: 22, color: AppColors.lightGrey),
          ),
        ],
      ),
      body: Stack(
        children: [
          MiniPlayerManager(
            hideMiniPlayerOnSplash: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionWidget(
                  title: 'Receive messages from anyone',
                  content: 'If you turn this setting of, only people you follow will be able to send you messages.',
                  onTap: () {
                    setState(() {
                      _receiveMessageAnyone = !_receiveMessageAnyone;
                    });
                    _saveSettings();
                  },
                  trailingWidget: CustomSwitch(
                    value: _receiveMessageAnyone,
                    onChanged: (bool value) {
                      setState(() {
                        _receiveMessageAnyone = value;
                      });
                      _saveSettings();
                    },
                    activeColor: AppColors.primary,
                  ),
                ),
                _buildInboxSettingsOption('Notification settings', Icons.arrow_forward_ios, () {
                  Navigator.push(context, createPageRoute(NotificationSettingsScreen(initialIndex: widget.initialIndex)));
                }),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 60,
            child: Align(
              alignment: Alignment.topCenter,
              child: InternetAwareScreen(
                title: 'Inbox Screen',
                connectedScreen: Container(),
              ),
            ),
          ),
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

  Widget _buildInboxSettingsOption(String text, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      splashColor: HelperFunctions.isDarkMode(context) ? AppColors.darkGrey.withAlpha((0.4 * 255).toInt()) : AppColors.grey.withAlpha((0.4 * 255).toInt()),
      highlightColor: HelperFunctions.isDarkMode(context) ? AppColors.darkGrey.withAlpha((0.4 * 255).toInt()) : AppColors.grey.withAlpha((0.4 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Row(
          children: [
            Text(text, style: const TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.normal)),
            const Spacer(),
            Icon(icon, size: 22),
          ],
        ),
      ),
    );
  }
}
