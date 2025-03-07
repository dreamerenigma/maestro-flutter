import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:maestro/common/widgets/app_bar/app_bar.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../home/screens/home_screen.dart';
import '../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../widgets/dialogs/new_message_bottom_dialog.dart';
import '../widgets/switches.dart';

class NotificationSettingsScreen extends StatefulWidget {
  final int initialIndex;

  const NotificationSettingsScreen({super.key, required this.initialIndex});

  @override
  NotificationSettingsScreenState createState() => NotificationSettingsScreenState();
}

class NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  late final int selectedIndex;
  final GetStorage _storage = GetStorage();
  late List<bool> _switchStatesPush;
  late List<bool> _switchStatesEmail;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;

    _switchStatesPush = List.generate(11, (index) {
      return _storage.read('push_switch_$index') ?? false;
    });
    _switchStatesEmail = List.generate(11, (index) {
      return _storage.read('email_switch_$index') ?? false;
    });
  }

  void _onSwitchChangedPush(int index, bool value) {
    setState(() {
      _switchStatesPush[index] = value;
    });
    _storage.write('push_switch_$index', value);
  }

  void _onSwitchChangedEmail(int index, bool value) {
    setState(() {
      _switchStatesEmail[index] = value;
    });
    _storage.write('email_switch_$index', value);
  }

  void _togglePushAllSwitches(bool value) {
    setState(() {
      for (int i = 0; i < _switchStatesPush.length; i++) {
        _switchStatesPush[i] = value;
        _storage.write('push_switch_$i', value);
      }
    });
  }

  void _toggleEmailAllSwitches(bool value) {
    setState(() {
      for (int i = 0; i < _switchStatesEmail.length; i++) {
        _switchStatesEmail[i] = value;
        _storage.write('email_switch_$i', value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: Text('Notification settings', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.cast, size: 23, color: AppColors.lightGrey),
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Text('Push notification', style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
              ),
              _notificationSectionWithText(
                'Enable all',
                CustomSwitch(
                  value: _switchStatesPush[0],
                  onChanged: (value) {
                    _onSwitchChangedPush(0, value);
                    _togglePushAllSwitches(value);
                  },
                  activeColor: AppColors.primary,
                ),
                'Turn on all mobile notifications or select which to receive.',
                true,
              ),
              ...List.generate(10, (index) {
                return _notificationSection(
                  _pushNotificationTitles[index + 1],
                  CustomSwitch(
                    value: _switchStatesPush[index + 1],
                    onChanged: (value) => _onSwitchChangedPush(index + 1, value),
                    activeColor: AppColors.primary,
                  ),
                );
              }),
              _buildNotificationOption('New message', Icons.arrow_forward_ios, () {
                showNewMessageBottomDialog(context);
              }),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
                child: Text('Email notification', style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
              ),
              _notificationSectionWithText(
                'Enable all',
                CustomSwitch(
                  value: _switchStatesEmail[0],
                  onChanged: (value) {
                    _onSwitchChangedEmail(0, value);
                    _toggleEmailAllSwitches(value);
                  },
                  activeColor: AppColors.primary,
                ),
                'Turn on all email notifications or select which to receive.',
                false,
              ),
              ...List.generate(10, (index) {
                return _notificationSection(
                  _emailNotificationTitles[index + 1],
                  CustomSwitch(
                    value: _switchStatesEmail[index + 1],
                    onChanged: (value) => _onSwitchChangedEmail(index + 1, value),
                    activeColor: AppColors.primary,
                  ),
                );
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

  Widget _notificationSectionWithText(String title, Widget trailingWidget, String subTitle, bool isPushNotification) {
    return InkWell(
      onTap: () {
      if (isPushNotification) {
        bool newValuePush = !_switchStatesPush[0];
        _onSwitchChangedPush(0, newValuePush);
        _togglePushAllSwitches(newValuePush);
      } else {
        bool newValueEmail = !_switchStatesEmail[0];
        _onSwitchChangedEmail(0, newValueEmail);
        _toggleEmailAllSwitches(newValueEmail);
      }
    },
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(title, style: const TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                ),
                trailingWidget,
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(subTitle, style: TextStyle(fontSize: AppSizes.fontSizeSm, color: context.isDarkMode ? AppColors.lightGrey : AppColors.grey, letterSpacing: -0.5)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notificationSection(String title, Widget trailingWidget) {
    return InkWell(
      onTap: () {
        int index = _pushNotificationTitles.indexOf(title);
        bool newValue = !_switchStatesPush[index];
        _onSwitchChangedPush(index, newValue);
      },
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(title, style: const TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
            ),
            trailingWidget,
          ],
        ),
      ),
    );
  }

  final List<String> _pushNotificationTitles = [
    'Enable all',
    'New follower',
    'Repost of your post',
    'New post by followed user',
    'Like and plays on your post',
    'Comment on your post',
    'New Maestro features and tips',
    'Surveys and feedback',
    'Maestro offers',
    'Suggested content',
    'Email notifications',
  ];

  final List<String> _emailNotificationTitles = [
    'Enable all',
    'New follower',
    'Repost of your post',
    'New post by followed user',
    'Like and plays on your post',
    'Comment on your post',
    'New Maestro features and tips',
    'Surveys and feedback',
    'Maestro offers',
    'Suggested content',
    'Email notifications',
  ];

  Widget _buildNotificationOption(String text, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Row(
          children: [
            Text(text, style: const TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
            const Spacer(),
            Icon(icon, size: 20),
          ],
        ),
      ),
    );
  }
}
