import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jam_icons/jam_icons.dart';
import 'package:maestro/features/library/screens/library/playlists/widgets/create_playlist_widget.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import '../../../../../api/apis.dart';
import '../../../../../common/widgets/app_bar/app_bar.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../routes/custom_page_route.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../home/screens/home_screen.dart';
import '../../../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../../../widgets/dialogs/create_playlist_bottom_dialog.dart';
import '../../../widgets/dialogs/filter_playlists_bottom_dialog.dart';
import '../../../widgets/input_fields/input_field.dart';

class AddTrackPlaylistScreen extends StatefulWidget {
  final List<Map<String, dynamic>> playlists;
  final int initialIndex;

  const AddTrackPlaylistScreen({super.key, required this.playlists, required this.initialIndex});

  @override
  State<AddTrackPlaylistScreen> createState() => _AddTrackPlaylistScreenState();
}

class _AddTrackPlaylistScreenState extends State<AddTrackPlaylistScreen> {
  late final int selectedIndex;
  late Future<Map<String, dynamic>?> userDataFuture;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredPlaylists = [];
  List<Map<String, dynamic>> playlists = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    userDataFuture = APIs.fetchUserData();
    selectedIndex = widget.initialIndex;
    filteredPlaylists = widget.playlists;
    _searchController.addListener(_filterPlaylists);
    _loadPlaylists();
  }

  Future<void> _loadPlaylists() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('Playlists').get();
      log('Loaded ${snapshot.docs.length} playlists');
      var playlistsData = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'title': doc['title'],
          'isPublic': doc['isPublic'],
          'releaseDate': doc['releaseDate'],
          'coverImage': doc['coverImage'],
          'authorName': doc['authorName'],
        };
      }).toList();

      await Future.delayed(const Duration(milliseconds: 700));

      setState(() {
        playlists = playlistsData;
        filteredPlaylists = playlistsData;
        isLoading = false;
      });
    } catch (e) {
      log('Error loading playlists: $e');
    }
  }

  void onPlaylistCreated() {
    var playlist = playlists.isNotEmpty ? playlists[0] : {};
    String title = playlist['title'] ?? 'Untitled Playlist';
    bool isPublic = playlist['isPublic'] ?? false;
    String authorName = playlist['authorName'] ?? 'Unknown author';
    String coverImage = playlist['coverImage'] ?? '';

    setState(() {
      playlists.add({
        'title': title,
        'isPublic': isPublic,
        'authorName': authorName,
        'coverImage': coverImage,
      });
    });
  }

  void _filterPlaylists() {
    setState(() {
      filteredPlaylists = widget.playlists.where((playlist) => playlist['title'].toLowerCase().contains(_searchController.text.toLowerCase())).toList();
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
        centerTitle: false,
        saveButtonText: 'Save',
        onSavePressed: () {},
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cast, size: 22, color: AppColors.grey),
          ),
        ],
      ),
      body: MiniPlayerManager(
        hideMiniPlayerOnSplash: false,
        child: FutureBuilder<Map<String, dynamic>?>(
          future: userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)));
            } else if (snapshot.hasError) {
              return Center(child: Text(S.of(context).errorLoadingProfile));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text(S.of(context).noUserDataFound));
            } else {
              final userData = snapshot.data!;

              return isLoading
                ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)))
                : ScrollConfiguration(
                  behavior: NoGlowScrollBehavior(),
                    child: RefreshIndicator(
                      onRefresh: _reloadData,
                      displacement: 0,
                      color: AppColors.primary,
                      backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.softGrey,
                      child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 6, top: 16, bottom: 12),
                          child: InputField(
                            controller: _searchController,
                            hintText: userData['name'] == null || widget.playlists.where((playlist) => playlist['authorName'] == userData['name']).isEmpty
                              ? 'Search playlists'
                              : 'Search ${filteredPlaylists.length} playlists',
                            icon: JamIcons.settingsAlt,
                            onIconPressed: () {
                              showFilterPlaylistsDialog(context);
                            },
                          ),
                        ),
                        CreatePlaylistWidget(onPlaylistCreated: () {
                          showCreatePlaylistDialog(context, onPlaylistCreated);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
          },
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
