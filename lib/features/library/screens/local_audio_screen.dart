import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:jam_icons/jam_icons.dart';
import 'package:maestro/common/widgets/app_bar/app_bar.dart';
import 'package:maestro/features/song_player/screens/song_player_screen.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import 'package:maestro/routes/custom_page_route.dart';
import 'package:on_audio_query/on_audio_query.dart' as audio_query;
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:math' as math;
import 'dart:developer';
import '../../../utils/constants/app_colors.dart';
import '../../../data/models/song/song_model.dart';
import '../../../domain/entities/song/song_entity.dart' as entity;
import '../../../domain/entities/song/song_entity.dart';
import '../../../utils/constants/app_images.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../home/models/song_with_download_info.dart';
import '../../home/screens/home_screen.dart';
import '../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../song_player/bloc/song_player_cubit.dart';
import '../../song_player/bloc/song_player_state.dart';
import '../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../widgets/dialogs/sort_by_local_audio_bottom_dialog.dart';
import '../widgets/input_fields/input_field.dart';

class LocalAudioScreen extends StatefulWidget {
  final List<SongEntity> songs;
  final int initialIndex;

  const LocalAudioScreen({super.key, required this.initialIndex, required this.songs});

  @override
  LocalAudioScreenState createState() => LocalAudioScreenState();
}

class LocalAudioScreenState extends State<LocalAudioScreen> {
  late final int selectedIndex;
  final audio_query.OnAudioQuery _audioQuery = audio_query.OnAudioQuery();
  List<SongModelWithDownloadInfo> _songs = [];
  List<SongModelWithDownloadInfo> _filteredSongs = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    _requestPermission();
    _searchController.addListener(_filterSongs);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _requestPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    _fetchSongs();
  }

  Future<bool> isConnectedToInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  Future<DateTime> _getFileDownloadTime(String filePath) async {
    try {
      File file = File(filePath);
      DateTime lastModified = await file.lastModified();
      return lastModified;
    } catch (e) {
      return DateTime.now();
    }
  }

  Future<void> _fetchSongs() async {
    log("Начинаю загрузку треков...");
    List<audio_query.SongModel> songs = await _audioQuery.querySongs();
    log("Загружено треков: ${songs.length}");

    List<SongModelWithDownloadInfo> songsWithDownloadTime = [];

    for (var song in songs) {
      String filePath = song.data;
      DateTime downloadTime = await _getFileDownloadTime(filePath);

      songsWithDownloadTime.add(SongModelWithDownloadInfo(song: song, downloadTime: downloadTime));
    }

    log("Треки с добавленным временем загрузки: ${songsWithDownloadTime.length}");

    setState(() {
      _songs = songsWithDownloadTime;
      _filteredSongs = songsWithDownloadTime;
    });

    log("Загрузка треков завершена.");
  }

  void _filterSongs() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSongs = _songs.where((songWithTime) {
        return songWithTime.song.title.toLowerCase().contains(query) || (songWithTime.song.artist?.toLowerCase().contains(query) ?? false);
      }).toList();
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
        title: const Text('Local audio', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
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
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 6, top: 16, bottom: 12),
                  child: InputField(
                    controller: _searchController,
                    hintText: 'Search ${_filteredSongs.length} tracks',
                    icon: JamIcons.settingsAlt,
                    onIconPressed: () {
                      showSortByLocalAudioBottomDialog(context);
                    },
                  ),
                ),
                Expanded(
                  child: _filteredSongs.isEmpty
                    ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)))
                    : ListView.builder(
                      itemCount: _filteredSongs.length,
                      itemBuilder: (context, index) {
                        final songWithTime = _filteredSongs[index];
                        final song = songWithTime.song;
                        final downloadTime = songWithTime.downloadTime;

                        return FutureBuilder<entity.SongEntity>(
                          future: convertSongModelToEntity(song, fetchFromFirestore: false),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)));
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData) {
                              return const SizedBox.shrink();
                            } else {
                              final songEntity = snapshot.data!;

                            return InkWell(
                              onTap: () async {
                                Navigator.push(context, createPageRoute(SongPlayerScreen(songEntity: songEntity)));
                              },
                              splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                              highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                                child: Row(
                                  children: [
                                    BlocBuilder<SongPlayerCubit, SongPlayerState>(
                                      builder: (context, state) {
                                        final isPlaying = state is SongPlayerLoaded && state.currentSong == songEntity && context.read<SongPlayerCubit>().audioPlayer.playing;

                                        return Material(
                                          color: AppColors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              context.read<SongPlayerCubit>().playOrPauseSong(songEntity);
                                            },
                                            splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                                            highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                                            borderRadius: BorderRadius.circular(AppSizes.cardRadiusXl),
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.darkGrey, width: 0.8)),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: Image.asset(
                                                      AppImages.defaultCover,
                                                      width: 65,
                                                      height: 65,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Icon(
                                                  isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                                                  color: context.isDarkMode ? AppColors.darkGrey : AppColors.grey,
                                                  size: 36,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            song.title,
                                            style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w600),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 5),
                                          Text(_formatDate(downloadTime), maxLines: 1, overflow: TextOverflow.ellipsis),
                                        ],
                                      ),
                                    ),

                                    SizedBox(width: 10),
                                    Text(_formatFileSize(song.size), style: TextStyle(color: AppColors.lightGrey, fontSize: AppSizes.fontSizeLm)),
                                  ],
                                ),
                              ),
                            );
                          }}
                        );
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

  Future<AssetEntity> fetchImageForSong(SongModel song) async {
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(type: RequestType.image);
    List<AssetEntity> images = await albums[0].getAssetListRange(start: 0, end: 1);
    return images[0];
  }

  String _formatFileSize(int sizeInBytes) {
    if (sizeInBytes <= 0) return "0 B";
    const sizes = ['B', 'KB', 'MB', 'GB', 'TB'];
    int index = (math.log(sizeInBytes) /  math.log(1024)).floor();
    double size = sizeInBytes /  math.pow(1024, index);
    return '${size.toStringAsFixed(2)} ${sizes[index]}';
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
