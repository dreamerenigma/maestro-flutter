import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../common/widgets/app_bar/app_bar.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../home/screens/home_screen.dart';
import '../../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';

class YourInsightsScreen extends StatefulWidget {
  final int initialIndex;

  const YourInsightsScreen({super.key, required this.initialIndex});

  @override
  State<YourInsightsScreen> createState() => _YourInsightsScreenState();
}

class _YourInsightsScreenState extends State<YourInsightsScreen> {
  late final int selectedIndex;
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;

    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      setState(() {
        isConnected = result != ConnectivityResult.none;
      });
    });

    _checkInternetConnection();
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

  Future<void> _openNetworkSettings() async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        _launchURL('app-settings:');
      } else if (Theme.of(context).platform == TargetPlatform.android) {
        _launchURL('android.settings.WIFI_SETTINGS');
      }
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _reloadData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: const Text('Your insights', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cast, size: 22, color: AppColors.grey),
          ),
          if (isConnected)
          IconButton(
            onPressed: () {},
            icon: const Icon(FeatherIcons.share2, size: 22, color: AppColors.grey),
          ),
        ],
      ),
      body: MiniPlayerManager(
        hideMiniPlayerOnSplash: false,
        child: ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: RefreshIndicator(
            onRefresh: _reloadData,
            displacement: 0,
            color: AppColors.primary,
            backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.softGrey,
            child: ListView(
              children: [
                if (!isConnected) _buildConnection(),
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

  Widget _buildConnection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('You are offline', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('It looks like you are not connected. Please try again.', style: TextStyle(fontSize: AppSizes.fontSizeSm)),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: () async {
                await _openNetworkSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.isDarkMode ? AppColors.white : AppColors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                side: BorderSide.none,
                elevation: 0,
                padding: EdgeInsets.all(16),
              ),
              child: Text('Get connected', style: TextStyle(color: context.isDarkMode ? AppColors.black : AppColors.white, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}
