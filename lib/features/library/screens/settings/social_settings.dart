import 'dart:developer';
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

class SocialSettings extends StatefulWidget {
  final int initialIndex;

  const SocialSettings({super.key, required this.initialIndex});

  @override
  State<SocialSettings> createState() => _SocialSettingsState();
}

class _SocialSettingsState extends State<SocialSettings> {
  late final int selectedIndex;
  bool _showFirstTopFan = false;
  bool _showFirstTopFanMyTracks = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    selectedIndex = widget.initialIndex;
  }

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_first_top_fan', _showFirstTopFan);
    await prefs.setBool('show_first_top_fan_my_tracks', _showFirstTopFanMyTracks);
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _showFirstTopFan = prefs.getBool('show_first_top_fan') ?? false;
      _showFirstTopFanMyTracks = prefs.getBool('show_first_top_fan_my_tracks') ?? false;
    });
  }

  Future<void> _handleSwitchChange(bool currentValue, String settingKey) async {
    setState(() {
      if (settingKey == 'show_first_top_fan') {
        _showFirstTopFan = !currentValue;
      } else if (settingKey == 'show_first_top_fan_my_tracks') {
        _showFirstTopFanMyTracks = !currentValue;
      }
    });

    await _saveSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: const Text('Social settings', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cast, size: 23),
          ),
        ],
      ),
      body: MiniPlayerManager(
        hideMiniPlayerOnSplash: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
              child: Text('Insight visibility', style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w400)),
            ),
            SectionWidget(
              title: 'Show when I\'m a First or Top Fan',
              content: 'You will appear in public First Fans and Top Fans lists',
              onTap: () {
                setState(() {
                  _showFirstTopFan = !_showFirstTopFan;
                });
                _saveSettings();
              },
              trailingWidget: CustomSwitch(
                value: _showFirstTopFan,
                onChanged: (bool value) {
                  setState(() {
                    _showFirstTopFan = value;
                  });
                  _saveSettings();
                },
                activeColor: AppColors.primary,
              ),
            ),
            SectionWidget(
              title: 'Show First and Top Fans for my tracks',
              content: 'Your First and Top Fans will appear on your tracks',
              onTap: () async {
                await _handleSwitchChange(_showFirstTopFanMyTracks, 'show_first_top_fan_my_tracks');
                _saveSettings();
              },
              trailingWidget: CustomSwitch(
                value: _showFirstTopFanMyTracks,
                onChanged: (bool value) async {
                  await _handleSwitchChange(value, 'show_first_top_fan_my_tracks');
                },
                activeColor: AppColors.primary,
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
