import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestro/common/widgets/app_bar/app_bar.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';

class YourTrueFriendsScreen extends StatefulWidget {
  final int initialIndex;

  const YourTrueFriendsScreen({super.key, required this.initialIndex});

  @override
  State<YourTrueFriendsScreen> createState() => YourTrueFriendsScreenState();
}

class YourTrueFriendsScreenState extends State<YourTrueFriendsScreen> {
  late final int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  Future<void> _reloadData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: const Text('Your true friends', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cast, size: 22, color: AppColors.grey),
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: RefreshIndicator(
          onRefresh: _reloadData,
          displacement: 0,
          color: AppColors.primary,
          backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.softGrey,
          child: ListView(
            children: [

            ],
          ),
        ),
      ),
    );
  }
}
