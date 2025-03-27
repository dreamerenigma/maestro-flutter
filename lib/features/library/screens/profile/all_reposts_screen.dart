import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/app_bar/app_bar.dart';
import '../../../../domain/entities/reposts/repost_entity.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../home/screens/home_screen.dart';
import '../../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';

class AllRepostsScreen extends StatefulWidget {
  final int initialIndex;

  const AllRepostsScreen({super.key, required this.initialIndex});

  @override
  State<AllRepostsScreen> createState() => _AllRepostsScreenState();
}

class _AllRepostsScreenState extends State<AllRepostsScreen> {
  late final int selectedIndex;
  List<RepostEntity> reposts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    _loadReposts();
  }

  Future<void> _loadReposts() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('Reposts').get();
      var repostsData = snapshot.docs.map((doc) {
        return RepostEntity.fromFirestore(doc);
      }).toList();

      setState(() {
        reposts = repostsData;
        isLoading = false;
      });
    } catch (e) {
      log('Error loading reposts: $e');
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
        title: const Text('Reposts', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cast, size: 22, color: AppColors.grey),
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
            child: Column(
              children: [

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
}
