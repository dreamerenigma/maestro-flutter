import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_colors.dart';
import '../../utils/screens/internet_aware_screen.dart';

class FeedScreen extends StatefulWidget {
  final VoidCallback onUpgradeTapped;

  const FeedScreen({super.key, required this.onUpgradeTapped});

  @override
  FeedScreenState createState() => FeedScreenState();
}

class FeedScreenState extends State<FeedScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = 1;
    _tabController.addListener(_onTabChanged);
    _checkInternetConnection();

    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      setState(() {
        isConnected = result != ConnectivityResult.none;
      });
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFeedBar(context),
              _buildTabsFeed(context),
            ],
          ),
          Positioned(
            top: kToolbarHeight + 70,
            left: 0,
            right: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: InternetAwareScreen(
                title: 'Feed Screen',
                connectedScreen: Container(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 16),
      child: Row(
        children: [
          const Text('Feed', style: TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.bold)),
          const Spacer(),
          isConnected ? GestureDetector(
            onTap: widget.onUpgradeTapped,
            child: const Text('UPGRADE', style: TextStyle(fontSize: AppSizes.fontSizeLm, fontWeight: FontWeight.bold, color: AppColors.primary)),
          ) : Container(),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.cast, size: 22),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTabsFeed(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: false,
            dividerColor: AppColors.transparent,
            indicatorColor: AppColors.transparent,
            labelColor: context.isDarkMode ? AppColors.white : AppColors.black,
            splashBorderRadius: BorderRadius.circular(25),
            unselectedLabelStyle: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.bold),
            unselectedLabelColor: AppColors.darkerGrey,
            tabAlignment: TabAlignment.center,
            indicatorPadding: EdgeInsets.zero,
            labelPadding: EdgeInsets.zero,
            overlayColor: WidgetStateProperty.all(AppColors.darkerGrey.withAlpha((0.2 * 255).toInt())),
            tabs: [
              _buildTab(context, 'Discover', 0),
              _buildTab(context, 'Following', 1),
            ],
            labelStyle: const TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 400,
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text('No Content', style: TextStyle(fontSize: AppSizes.fontSizeLg, fontWeight: FontWeight.bold)),
                      SizedBox(height: 6),
                      Text('Please follow some artists first. Pull to try again.',
                        style: TextStyle(fontSize: AppSizes.fontSizeSm),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text('No Content', style: TextStyle(fontSize: AppSizes.fontSizeLg, fontWeight: FontWeight.bold)),
                      SizedBox(height: 6),
                      Text('Please follow some artists first. Pull to try again.',
                        style: TextStyle(fontSize: AppSizes.fontSizeSm),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, String text, int index) {
    final isSelected = _tabController.index == index;

    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppColors.darkGrey.withAlpha((0.7 * 255).toInt()) : AppColors.transparent,
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Tab(
        child: Text(
          text,
          style: TextStyle(color: isSelected ? AppColors.white : AppColors.darkerGrey, fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
