import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../common/widgets/app_bar/app_bar.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../home/screens/home_screen.dart';
import '../../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../../widgets/sections/section_widget.dart';
import '../../widgets/switches.dart';

class AnalyticsScreen extends StatefulWidget {
  final int initialIndex;

  const AnalyticsScreen({super.key, required this.initialIndex});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  late final int selectedIndex;
  bool _showHelpUsageDeviceData = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    selectedIndex = widget.initialIndex;
  }

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_help_usage_device_data', _showHelpUsageDeviceData);
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _showHelpUsageDeviceData = prefs.getBool('show_help_usage_device_data') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: const Text('Analytics', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
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
            SectionWidget(
              title: 'Help improve Maestro by sending us regular usage and device data',
              onTap: () {
                setState(() {
                  _showHelpUsageDeviceData = !_showHelpUsageDeviceData;
                });
                _saveSettings();
              },
              trailingWidget: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: CustomSwitch(
                  value: _showHelpUsageDeviceData,
                  onChanged: (bool value) {
                    setState(() {
                      _showHelpUsageDeviceData = value;
                    });
                    _saveSettings();
                  },
                  activeColor: AppColors.primary,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Changes require an app restart to become effective.', style: TextStyle(color: AppColors.grey, fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.normal, letterSpacing: -0.5)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: InkWell(
                      onTap: () {},
                      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.black),
                            children: [
                              TextSpan(
                                text: 'Learn more in our Privacy Policy',
                                style: TextStyle(color: AppColors.blue, fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w400, decoration: TextDecoration.none),
                                recognizer: TapGestureRecognizer()..onTap = () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
}
