import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jam_icons/jam_icons.dart';
import 'package:maestro/common/widgets/app_bar/app_bar.dart';
import '../../../../domain/entities/song/song_entity.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../home/screens/home_screen.dart';
import '../../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../widgets/dialogs/filter_albums_bottom_dialog.dart';
import '../../widgets/input_fields/input_field.dart';

class AlbumsScreen extends StatefulWidget {
  final List<SongEntity> albums;
  final int initialIndex;

  const AlbumsScreen({super.key, required this.albums, required this.initialIndex});

  @override
  State<AlbumsScreen> createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends State<AlbumsScreen> {
  late final int selectedIndex;
  final TextEditingController _searchController = TextEditingController();
  List<SongEntity> filteredAlbums = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    filteredAlbums = widget.albums;
    _searchController.addListener(_filterSongs);
    _loadAlbums();
  }

  Future<void> _loadAlbums() async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        filteredAlbums = widget.albums;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      log('Error loading albums: $e');
    }
  }

  void _filterSongs() {
    setState(() {
      filteredAlbums = widget.albums.where((song) => song.title.toLowerCase().contains(_searchController.text.toLowerCase())).toList();
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
        title: const Text('Albums', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
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
        child: isLoading
          ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)))
          : ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: RefreshIndicator(
            onRefresh: _reloadData,
            displacement: 0,
            color: AppColors.primary,
            backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.softGrey,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 6, top: 16, bottom: 12),
                  child: InputField(
                    controller: _searchController,
                    hintText: 'Search ${filteredAlbums.length} albums',
                    icon: JamIcons.settingsAlt,
                    onIconPressed: () {
                      showFilterAlbumsDialog(context);
                    },
                  ),
                ),
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
