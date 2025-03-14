import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jam_icons/jam_icons.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../../utils/screens/internet_aware_screen.dart';
import '../widgets/dialogs/notification_bottom_dialog.dart';
import '../widgets/nav_bar/bottom_nav_bar.dart';
import 'home_screen.dart';

class NotificationsScreen extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const NotificationsScreen({super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final GetStorage _storageBox = GetStorage();
  late String selectedOption;
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    selectedOption = _storageBox.read('selectedNotificationOption') ?? S.of(context).showAllNotify;

    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      setState(() {
        isConnected = result != ConnectivityResult.none;
      });
    });

    _checkInternetConnection();
  }

  Future<void> _openNotificationDialog() async {
    final newOption = await showNotificationDialog(context, selectedOption);
    if (newOption != null && newOption != selectedOption) {
      setState(() {
        selectedOption = newOption;
      });
      _storageBox.write('selectedNotificationOption', newOption);
    }
  }

  Future<void> _checkInternetConnection() async {
    bool hasConnection;
    try {
      final result = await InternetAddress.lookup('google.com');
      hasConnection = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      hasConnection = false;
    }
    setState(() {
      isConnected = hasConnection;
    });
  }

  Future<void> _reloadData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: Text(S.of(context).notifications, style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: _openNotificationDialog,
            icon: Icon(
              JamIcons.settingsAlt,
              size: 23,
              color: isConnected ? (context.isDarkMode ? AppColors.white : AppColors.black) : AppColors.darkGrey,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cast, size: 23),
          ),
        ],
      ),
      body: Stack(
        children: [
          ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: RefreshIndicator(
              onRefresh: _reloadData,
              displacement: 0,
              color: AppColors.primary,
              backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.softGrey,
              child: MiniPlayerManager(
                hideMiniPlayerOnSplash: false,
                child: ListView(
                  children: [
                    const SizedBox(height: 10),
                    _buildSection(S.of(context).nothingHappenedYet, S.of(context).nothingHappenedYetSubtitle),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 60,
            child: Align(
              alignment: Alignment.topCenter,
              child: InternetAwareScreen(title: 'Notifications Screen', connectedScreen: Container()),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: widget.selectedIndex,
        onItemTapped: (index) {
          Navigator.pushReplacement(context, createPageRoute(HomeScreen(initialIndex: index)));
        },
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return InkWell(
      onTap: () {},
      splashColor: AppColors.darkGrey.withAlpha((0.3 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.3 * 255).toInt()),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                content,
                style: const TextStyle(fontSize: AppSizes.fontSizeSm, color: AppColors.darkerGrey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

