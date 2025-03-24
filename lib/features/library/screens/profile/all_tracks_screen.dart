import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/app_bar/app_bar.dart';
import '../../../../domain/entities/song/song_entity.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../home/screens/home_screen.dart';
import '../../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../widgets/items/track_item.dart';

class AllTracksScreen extends StatefulWidget {
  final List<dynamic> songs;
  final int initialIndex;

  const AllTracksScreen({super.key, required this.songs, required this.initialIndex});

  @override
  State<AllTracksScreen> createState() => _AllTracksScreenState();
}

class _AllTracksScreenState extends State<AllTracksScreen> {
  late final int selectedIndex;
  List<SongEntity> songs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    _loadTracks();
  }

  Future<void> _loadTracks() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('Songs').get();
      var songsData = snapshot.docs.map((doc) {
        return SongEntity.fromFirestore(doc);
      }).toList();
      setState(() {
        songs = songsData;
        isLoading = false;
      });
    } catch (e) {
      log('Error loading tracks: $e');
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
        title: const Text('Tracks', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
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
            child: isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : songs.isEmpty
                ? const Center(child: Text('No tracks available', style: TextStyle(color: AppColors.grey)))
                : Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      final song = songs[index];
                      return TrackItem(
                        song: song,
                        onTap: () {},
                        showMoreButton: false,
                      );
                    },
                  ),
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
