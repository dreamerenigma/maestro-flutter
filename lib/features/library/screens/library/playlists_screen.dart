import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:jam_icons/jam_icons.dart';
import 'package:maestro/features/library/screens/library/playlist_screen.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import '../../../../common/widgets/app_bar/app_bar.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../home/screens/home_screen.dart';
import '../../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../../song_player/bloc/song_player_cubit.dart';
import '../../../song_player/bloc/song_player_state.dart';
import '../../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../../widgets/dialogs/create_playlist_bottom_dialog.dart';
import '../../widgets/dialogs/filter_playlists_bottom_dialog.dart';
import '../../widgets/dialogs/playlist_bottom_dialog.dart';
import '../../widgets/input_fields/input_field.dart';

class PlaylistsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> playlists;
  final int initialIndex;

  const PlaylistsScreen({super.key, required this.playlists, required this.initialIndex});

  @override
  State<PlaylistsScreen> createState() => PlaylistsScreenState();
}

class PlaylistsScreenState extends State<PlaylistsScreen> {
  late final int selectedIndex;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredPlaylists = [];
  List<Map<String, dynamic>> playlists = [];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    filteredPlaylists = widget.playlists;
    _searchController.addListener(_filterPlaylists);
    _loadPlaylists();
  }

  Future<void> _loadPlaylists() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('Playlists').get();
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
      setState(() {
        playlists = playlistsData;
      });
    } catch (e) {
      log('Error loading playlists: $e');
    }
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
        title: const Text('Playlists', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cast, size: 22, color: AppColors.grey),
          ),
          IconButton(
            onPressed: () {
              showCreatePlaylistDialog(context);
            },
            icon: const Icon(Icons.add_circle_outline_rounded, size: 26, color: AppColors.grey),
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
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 6, top: 16, bottom: 12),
                  child: InputField(
                    controller: _searchController,
                    hintText: 'Search ${filteredPlaylists.length} playlists',
                    icon: JamIcons.settingsAlt,
                    onIconPressed: () {
                      showFilterPlaylistsDialog(context);
                    },
                  ),
                ),
                _buildCreatePlaylist(),
                _buildPlaylistsList(),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.playlists.length,
                  itemBuilder: (context, index) {
                    final playlist = widget.playlists[index];

                    return InkWell(
                      onTap: () async {
                        // showSongPlayerDialog(context, songEntity: playlist);
                      },
                      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, createPageRoute(PlaylistScreen(playlists: [], initialIndex: widget.initialIndex)));
                                  },
                                  child: BlocBuilder<SongPlayerCubit, SongPlayerState>(
                                    builder: (context, state) {
                                      final isPlaying = state is SongPlayerLoaded && state.currentSong == playlist && context.read<SongPlayerCubit>().audioPlayer.playing;
                                      return Container(
                                        height: 45,
                                        width: 45,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: context.isDarkMode ? AppColors.darkGrey : AppColors.grey,
                                        ),
                                        child: Icon(
                                          isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                                          color: context.isDarkMode ? AppColors.darkerGrey : AppColors.grey,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(height: 20),
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

  Widget _buildPlaylistsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        final playlist = playlists[index];

        return InkWell(
          onTap: () {
            Navigator.push(context, createPageRoute(PlaylistScreen(initialIndex: widget.initialIndex, playlists: playlists)));
          },
          splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
          highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
          child: Padding(
            padding: const EdgeInsets.only(left: 18, right: 8, top: 12, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    playlist['coverImage'] != null
                      ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.darkGrey, width: 0.8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            playlist['coverImage'],
                            width: 65,
                            height: 65,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : const Icon(Icons.music_note, size: 50, color: AppColors.grey),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(playlist['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeMd)),
                        Text(playlist['authorName'] ?? 'Unknown author', style: TextStyle(fontWeight: FontWeight.w400, fontSize: AppSizes.fontSizeSm, color: AppColors.grey)),
                        Row(
                          children: [
                            Text('Playlist' ' · ' '0 tracks', style: TextStyle(fontWeight: FontWeight.w400, fontSize: AppSizes.fontSizeSm, color: AppColors.grey)),
                            const SizedBox(width: 8),
                            playlist['isPublic'] == false ? Container(width: 15, height: 15, decoration: BoxDecoration(color: AppColors.grey, shape: BoxShape.circle),
                                child: Icon(Icons.lock, size: 13, color: AppColors.black),
                              )
                            : SizedBox.shrink(),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    showPlaylistBottomDialog(context, playlists, index);
                  },
                  icon: Icon(Icons.more_vert_rounded, size: 24, color: context.isDarkMode ? AppColors.lightGrey : AppColors.darkerGrey),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox.shrink(),
    );
  }

  Widget _buildCreatePlaylist() {
    return InkWell(
      onTap: () {
        showCreatePlaylistDialog(context);
      },
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 14, bottom: 14),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: AppColors.steelGrey,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(Icons.add_circle_outline, color: AppColors.lightGrey, size: 30),
              ),
            ),
            SizedBox(width: 16.0),
            Text('Create playlist', style: TextStyle(color: AppColors.white, fontSize: 18.0)),
          ],
        ),
      ),
    );
  }

  String truncateWithEllipsis(int cutoff, String text) {
    return (text.length <= cutoff) ? text : '${text.substring(0, cutoff)}...';
  }
}
