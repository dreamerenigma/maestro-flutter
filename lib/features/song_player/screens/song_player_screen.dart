import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:maestro/common/widgets/buttons/favorite_button.dart';
import 'package:maestro/features/library/screens/library/tracks/behind_this_track_screen.dart';
import 'package:maestro/routes/custom_page_route.dart';
import '../../../api/apis.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../data/services/song/song_firebase_service.dart';
import '../../../utils/constants/app_images.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../domain/entities/song/song_entity.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../../utils/formatters/formatter.dart';
import '../../library/widgets/dialogs/info_track_bottom_dialog.dart';
import '../bloc/song_player_cubit.dart';
import '../bloc/song_player_state.dart';
import 'package:palette_generator/palette_generator.dart';
import '../widgets/buttons/device_icon_button.dart';
import '../widgets/dialogs/share_track_bottom_dialog.dart';
import '../widgets/sliders/song_slider.dart';
import 'comments_screen.dart';
import 'next_up_screen.dart';

class SongPlayerScreen extends StatefulWidget {
  final int initialIndex;
  final SongEntity song;
  final bool isPlaying;

  const SongPlayerScreen({super.key, required this.song, required this.isPlaying, required this.initialIndex});

  @override
  SongPlayerScreenState createState() => SongPlayerScreenState();
}

class SongPlayerScreenState extends State<SongPlayerScreen> {
  bool isShuffleActive = false;
  bool _isRepeated = false;
  final GetStorage _storageBox = GetStorage();
  late Future<Map<String, dynamic>?> userDataFuture;
  Color backgroundColor = AppColors.transparent;
  Timer? _timer;
  late String coverPath;

  List<String> cover = [
    AppImages.defaultCover1,
    AppImages.defaultCover2,
    AppImages.defaultCover3,
    AppImages.defaultCover4,
    AppImages.defaultCover5,
    AppImages.defaultCover6,
  ];

  String? _getArtistFromTitle(String? title) {
    if (title != null && title.contains('-')) {
      final parts = title.split('-');
      return parts[0].trim();
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    userDataFuture = APIs.fetchUserData();
    onSongPlayed(widget.song.songId);
    coverPath = widget.song.cover;
    isShuffleActive = _storageBox.read('isShuffleActive') ?? false;
    if (widget.isPlaying) {
      context.read<SongPlayerCubit>().playOrPauseSong(widget.song);
    }
    _getDominantColor();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void onSongPlayed(String songId) {
    final SongFirebaseServiceImpl songService = SongFirebaseServiceImpl();
    songService.incrementListenCount(songId);
  }

  void _toggleShuffle() {
    setState(() {
      isShuffleActive = !isShuffleActive;
    });

    _storageBox.write('isShuffleActive', isShuffleActive);
  }

  Future<void> _getDominantColor() async {
    if (coverPath.isNotEmpty) {
      ImageProvider imageProvider;

      if (coverPath.startsWith('http')) {
        imageProvider = NetworkImage(coverPath);
      } else {
        imageProvider = FileImage(File(coverPath));
      }

      final PaletteGenerator palette = await PaletteGenerator.fromImageProvider(imageProvider);

      setState(() {
        backgroundColor = palette.dominantColor?.color ?? Colors.transparent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final coverPath = widget.song.cover;

    return Scaffold(
      backgroundColor: context.isDarkMode ? AppColors.backgroundColor : AppColors.white,
      appBar: BasicAppBar(
        title: const Text('Now playing', style: TextStyle(fontSize: AppSizes.fontSizeLg)),
        rotateIcon: true,
        removeIconContainer: true,
        action: InkWell(
          splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
          highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
          borderRadius: BorderRadius.circular(AppSizes.cardRadiusXl),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 6, top: 8, bottom: 8),
            child: SvgPicture.asset(
              AppVectors.playNext,
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(
                context.isDarkMode ? AppColors.white : AppColors.black,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }
          final userData = snapshot.data!;
          return Stack(
            children: [
              Positioned.fill(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: coverPath.isNotEmpty
                            ? (coverPath.startsWith('http') ? NetworkImage(coverPath) : FileImage(File(coverPath)))
                            : const AssetImage(AppImages.defaultCover1),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.transparent,
                              AppColors.black.withAlpha((0.7 * 255).toInt()),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withAlpha((0.4 * 255).toInt()),
                              offset: Offset(0, 10),
                              blurRadius: 15,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              BlocProvider(
                create: (_) => SongPlayerCubit()..loadSong(widget.song),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildSongCover(widget.song),
                    const SizedBox(height: 20),
                    _buildSongDetail(),
                    const SizedBox(height: 30),
                    _buildSongPlayer(context),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomPanel(userData),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget _buildSongCover(SongEntity song) {
    final coverPath = song.cover;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        height: MediaQuery.of(context).size.height / 2.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: coverPath.isNotEmpty
              ? (coverPath.startsWith('http') ? NetworkImage(coverPath) : FileImage(File(coverPath)))
              : const AssetImage(AppImages.defaultCover1),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withAlpha((0.3 * 255).toInt()),
              offset: const Offset(0, 4),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSongDetail() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            color: AppColors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(context, createPageRoute(BehindThisTrackScreen(song: widget.song, initialIndex: widget.initialIndex)));
              },
              splashColor: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
              highlightColor: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.song.title.split('.').first,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeXl),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.song.uploadedBy.isNotEmpty == true
                        ? widget.song.uploadedBy
                        : (widget.song.artist.isNotEmpty == true && widget.song.artist != '<unknown>')
                          ? widget.song.artist
                          : _getArtistFromTitle(widget.song.title) ?? 'Unknown Artist',
                      style: const TextStyle(color: AppColors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_rounded, color: AppColors.buttonGrey, size: 30),
          ),
          DeviceIconButton(),
        ],
      ),
    );
  }

  Widget _buildSongPlayer(BuildContext context) {
    return BlocBuilder<SongPlayerCubit, SongPlayerState>(
      builder: (context, state) {
        if (state is SongPlayerLoading) {
          return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)));
        }
        if (state is SongPlayerLoaded) {
          final songPlayerCubit = context.read<SongPlayerCubit>();
          final songPosition = songPlayerCubit.songPosition.inSeconds.toDouble();
          final songDuration = songPlayerCubit.songDuration.inSeconds.toDouble();
          final isPlaying = context.read<SongPlayerCubit>().audioPlayer.playing;

          if (isPlaying && _timer == null) {
            _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
              setState(() {});
            });
          } else if (!isPlaying && _timer != null) {
            _timer?.cancel();
          }

          return Padding(
            padding: const EdgeInsets.only(left: 16, right:16, bottom: 30),
            child: Column(
              children: [
                CustomSlider(
                  value: songPosition >= 0 && songPosition <= songDuration ? songPosition : 0,
                  min: 0.0,
                  max: songDuration > 0 ? songDuration : 1,
                  onChanged: (value) {
                    final position = Duration(seconds: value.toInt());
                    songPlayerCubit.audioPlayer.seek(position);
                  },
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.darkerGrey,
                  thumbSize: 21,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(Formatter.formatDuration(songPlayerCubit.songPosition, isRemaining: true), style: TextStyle(fontSize: AppSizes.fontSizeLm, fontWeight: FontWeight.w200)),
                    Text(Formatter.formatDuration(songPlayerCubit.songDuration - songPlayerCubit.songPosition), style: TextStyle(fontSize: AppSizes.fontSizeLm, fontWeight: FontWeight.w200)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        songPlayerCubit.toggleRepeat();
                        _toggleShuffle();
                      },
                      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                      icon: Icon(Bootstrap.shuffle, color: isShuffleActive ? AppColors.primary : AppColors.darkerGrey, size: 22),
                    ),
                    const SizedBox(width: 16),
                    _controlButton(
                      context: context,
                      icon: FontAwesome.backward_step_solid,
                      onTap: () {
                        songPlayerCubit.seekBackward(const Duration(seconds: 10));
                      },
                    ),
                    const SizedBox(width: 20),
                    InkWell(
                      onTap: () {
                        songPlayerCubit.playOrPauseSong();
                      },
                      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                        ),
                        child: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: AppColors.black,
                          size: 46,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    _controlButton(
                      context: context,
                      icon: FontAwesome.forward_step_solid,
                      onTap: () {
                        songPlayerCubit.seekForward(const Duration(seconds: 10));
                      },
                    ),
                    const SizedBox(width: 5),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isRepeated = !_isRepeated;
                        });
                      },
                      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                      icon: Icon(
                        _isRepeated ? BootstrapIcons.repeat_1 : BootstrapIcons.repeat,
                        color: AppColors.darkerGrey,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        if (state is SongPlayerFailure) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        }
        return Container();
      },
    );
  }

  Widget _controlButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
        highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: const EdgeInsets.all(15.0),
          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.transparent),
          child: Icon(icon, color: AppColors.white, size: 36),
        ),
      ),
    );
  }

  Widget _buildBottomPanel(Map<String, dynamic> userData) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.youngNight,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Material(
            color: AppColors.transparent,
            child: InkWell(
              onTap: () {},
              splashColor: AppColors.darkGrey.withAlpha((0.8 * 255).toInt()),
              highlightColor: AppColors.darkGrey.withAlpha((0.8 * 255).toInt()),
              borderRadius: BorderRadius.circular(AppSizes.cardRadiusXl),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        FavoriteButton(songEntity: widget.song),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Material(
            color: AppColors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(context, createPageRoute(CommentsScreen(song: widget.song, initialIndex: widget.initialIndex, comments: [])));
              },
              splashColor: AppColors.darkGrey.withAlpha((0.8 * 255).toInt()),
              highlightColor: AppColors.darkGrey.withAlpha((0.8 * 255).toInt()),
              borderRadius: BorderRadius.circular(AppSizes.cardRadiusXl),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppVectors.comment,
                      colorFilter: ColorFilter.mode(context.isDarkMode ? AppColors.white : AppColors.black, BlendMode.srcIn),
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    if (widget.song.commentsCount > 0)
                    Text(
                      '${widget.song.commentsCount}',
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: context.isDarkMode ? AppColors.white : AppColors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              showShareTrackBottomDialog(context, userData, widget.song);
            },
            icon: Icon(FeatherIcons.share2, size: 26, color: context.isDarkMode ? AppColors.white : AppColors.black),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context, createPageRoute(NextUpScreen()));
            },
            icon: Icon(Icons.playlist_play_rounded, size: 34, color: context.isDarkMode ? AppColors.white : AppColors.black),
          ),
          IconButton(
            onPressed: () {
              showInfoTrackBottomDialog(
                context,
                userData,
                widget.song,
                shouldShowPlayNext: false,
                shouldShowPlayLast: false,
                initialChildSize: 0.883,
                maxChildSize: 0.883,
              );
            },
            icon: Icon(Icons.more_vert_rounded, size: 24, color: context.isDarkMode ? AppColors.white : AppColors.black),
          ),
        ],
      ),
    );
  }
}
