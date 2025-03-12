import 'dart:async';
import 'dart:io';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../data/services/song/song_firebase_service.dart';
import '../../../utils/constants/app_images.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../domain/entities/song/song_entity.dart';
import '../../../utils/constants/app_vectors.dart';
import '../bloc/song_player_cubit.dart';
import '../bloc/song_player_state.dart';
import '../widgets/sliders/song_slider.dart';
import 'package:palette_generator/palette_generator.dart';

class SongPlayerScreen extends StatefulWidget {
  final SongEntity song;
  final bool isPlaying;

  const SongPlayerScreen({super.key, required this.song, required this.isPlaying});

  @override
  SongPlayerScreenState createState() => SongPlayerScreenState();
}

class SongPlayerScreenState extends State<SongPlayerScreen> {
  bool isShuffleActive = false;
  bool _isRepeated = false;
  final GetStorage _storageBox = GetStorage();
  Color backgroundColor = AppColors.transparent;
  Timer? _timer;

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
    onSongPlayed(widget.song.songId);
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
    final coverPath = widget.song.cover;
    if (coverPath.isNotEmpty) {
      ImageProvider imageProvider;

      if (coverPath.startsWith('http')) {
        imageProvider = NetworkImage(coverPath) as ImageProvider<Object>;
      } else {
        imageProvider = FileImage(File(coverPath)) as ImageProvider<Object>;
      }

      final PaletteGenerator palette = await PaletteGenerator.fromImageProvider(imageProvider);

      setState(() {
        backgroundColor = palette.dominantColor?.color ?? AppColors.transparent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            padding: const EdgeInsets.all(10.0),
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
      body: BlocProvider(
        create: (_) => SongPlayerCubit()..loadSong(widget.song),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              _buildSongCover(widget.song),
              const SizedBox(height: 20),
              _buildSongDetail(),
              const SizedBox(height: 30),
              _buildSongPlayer(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSongCover(SongEntity song) {
    final coverPath = song.cover;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: coverPath.isNotEmpty
              ? (coverPath.startsWith('http') ? NetworkImage(coverPath) : FileImage(File(coverPath)))
              : const AssetImage(AppImages.defaultCover1),
          ),
        ),
      ),
    );
  }

  Widget _buildSongDetail() {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
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
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_rounded, color: AppColors.darkerGrey, size: 30),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded, color: AppColors.darkerGrey, size: 28),
          ),
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    Text(formatDuration(songPlayerCubit.songPosition, isRemaining: true), style: TextStyle(fontSize: AppSizes.fontSizeLm, fontWeight: FontWeight.w200)),
                    Text(formatDuration(songPlayerCubit.songDuration - songPlayerCubit.songPosition), style: TextStyle(fontSize: AppSizes.fontSizeLm, fontWeight: FontWeight.w200)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.transparent,
        ),
        child: Icon(
          icon,
          color: AppColors.white,
          size: 36,
        ),
      ),
    );
  }

  String formatDuration(Duration duration, {bool isRemaining = false}) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    final formattedTime = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return isRemaining ? formattedTime : '-$formattedTime';
  }
}
