import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:maestro/common/widgets/app_bar/app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_colors.dart';
import '../../home/screens/home_screen.dart';
import '../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../../utils/widgets/no_glow_scroll_behavior.dart';
import '../widgets/dialogs/clear_app_cache_dialog.dart';
import '../widgets/dialogs/refresh_app_change_feed_dialog.dart';
import '../widgets/sections/section_widget.dart';
import '../widgets/switches.dart';
import 'app_icon_screen.dart';

class BasicSettingsScreen extends StatefulWidget {
  final int initialIndex;

  const BasicSettingsScreen({super.key, required this.initialIndex});

  @override
  BasicSettingsScreenState createState() => BasicSettingsScreenState();
}

class BasicSettingsScreenState extends State<BasicSettingsScreen> {
  late final int selectedIndex;
  bool _showCommentsOnWaveform = false;
  bool _experienceNewFeed = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    selectedIndex = widget.initialIndex;
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _showCommentsOnWaveform = prefs.getBool('show_comments_on_waveform') ?? false;
      _experienceNewFeed = prefs.getBool('experience_new_feed') ?? false;
    });
  }

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_comments_on_waveform', _showCommentsOnWaveform);
    await prefs.setBool('experience_new_feed', _experienceNewFeed);
    log('Settings saved: $_showCommentsOnWaveform, $_experienceNewFeed');
  }

  Future<void> _handleSwitchChange(bool currentValue, String settingKey) async {
    bool confirmChange = await showRefreshAppChangeFeedDialog(context);

    if (confirmChange) {
      setState(() {
        if (settingKey == 'show_comments_on_waveform') {
          _showCommentsOnWaveform = !currentValue;
        } else if (settingKey == 'experience_new_feed') {
          _experienceNewFeed = !currentValue;
        }
      });

      await _saveSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: const Text('Basic settings', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.cast, size: 23, color: AppColors.lightGrey),
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
              SectionWidget(
                title: 'Clear application cache',
                content: 'Clear the application cache to free up memory on your device',
                trailingWidget: null,
                onTap: () {
                  showClearAppCacheDialog(context);
                },
              ),
              SectionWidget(
                title: 'Show comments on the waveform',
                content: 'Waveform comments are visible in the fullscreen player',
                onTap: () {
                  setState(() {
                    _showCommentsOnWaveform = !_showCommentsOnWaveform;
                  });
                  _saveSettings();
                },
                trailingWidget: CustomSwitch(
                  value: _showCommentsOnWaveform,
                  onChanged: (bool value) {
                    setState(() {
                      _showCommentsOnWaveform = value;
                    });
                    _saveSettings();
                  },
                  activeColor: AppColors.primary,
                ),
              ),
              SectionWidget(
                title: 'Experience the new feed',
                content: 'Switching this off will bring back the old feed for a limited period of time.',
                onTap: () async {
                  await _handleSwitchChange(_experienceNewFeed, 'experience_new_feed');
                  _saveSettings();
                },
                trailingWidget: CustomSwitch(
                  value: _experienceNewFeed,
                  onChanged: (bool value) async {
                    await _handleSwitchChange(value, 'experience_new_feed');
                  },
                  activeColor: AppColors.primary,
                ),
              ),
              SectionWidget(
                title: 'Change app icon',
                content: 'Custom app icons to match your style',
                trailingWidget: null,
                onTap: () {
                  Navigator.push(context, createPageRoute(AppIconScreen(initialIndex: widget.initialIndex)));
                },
              ),
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
}
