import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../common/widgets/favorite_button/favorite_button.dart';
import '../../../utils/constants/app_images.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_urls.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../data/sources/song/song_firebase_service.dart';
import '../../../domain/entities/song/song_entity.dart';
import '../bloc/song_player_cubit.dart';
import '../bloc/song_player_state.dart';
import '../widgets/sliders/song_slider.dart';

class SongPlayerScreen extends StatefulWidget {
  final SongEntity songEntity;

  const SongPlayerScreen({super.key, required this.songEntity});

  @override
  SongPlayerScreenState createState() => SongPlayerScreenState();
}

class SongPlayerScreenState extends State<SongPlayerScreen> {
  Timer? _seekTimer;
  bool _isForward = false;
  bool isShuffleActive = false;
  bool _isRepeated = false;
  final GetStorage _storageBox = GetStorage();

  @override
  void initState() {
    super.initState();
    onSongPlayed(widget.songEntity.songId);
    isShuffleActive = _storageBox.read('isShuffleActive') ?? false;
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

  Future<String?> _getCoverImage() async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final baseCoverPath = 'covers/${widget.songEntity.artist} - ${widget.songEntity.title}';

      List<String> extensions = ['jpg', 'jpeg', 'png'];

      for (var extension in extensions) {
        final coverPath = '$baseCoverPath.$extension';
        final fileRef = storageRef.child(coverPath);

        try {
          final url = await fileRef.getDownloadURL();
          log('Cover found in Firebase Storage: $url');
          return url;
        } catch (e) {
          log('No cover found for $coverPath: $e');
        }
      }
    } catch (e) {
      log('Error loading cover image from Firebase Storage: $e');
    }

    final directory = await getApplicationDocumentsDirectory();
    final localCoverPath = '${directory.path}/covers/${widget.songEntity.coverPath}';
    log('Checking local cover path: $localCoverPath');

    if (File(localCoverPath).existsSync()) {
      log('Local cover exists: $localCoverPath');
      return localCoverPath;
    } else {
      log('Local cover does not exist');
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: const Text('Now playing', style: TextStyle(fontSize: AppSizes.fontSizeLg)),
        rotateIcon: true,
        removeIconContainer: true,
        action: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert_rounded, size: 22),
        ),
      ),
      body: BlocProvider(
        create: (_) => SongPlayerCubit()..loadSong(
          '${AppURLs.songFirestorage}${widget.songEntity.artist} - ${widget.songEntity.title}.mp3?${AppURLs.mediaAlt}',
          widget.songEntity,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              _songCover(),
              const SizedBox(height: 20),
              _songDetail(),
              const SizedBox(height: 30),
              _songPlayer(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _songCover() {
    return FutureBuilder<String?>(
      future: _getCoverImage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)));
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading cover'));
        }
        if (snapshot.hasData) {
          final coverPath = snapshot.data;
          if (coverPath == null) {
            log('No cover path found, showing default image');
          }
          return Container(
            height: MediaQuery.of(context).size.height / 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: coverPath != null
                  ? (coverPath.startsWith('http') ? NetworkImage(coverPath) : FileImage(File(coverPath)))
                  : const AssetImage(AppImages.defaultCover),
              ),
            ),
          );
        }
        return const Center(child: Text('No cover available'));
      },
    );
  }

  Widget _songDetail() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.darkerGrey, size: 30),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.songEntity.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeXl),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 5),
              Text(
                widget.songEntity.artist,
                style: const TextStyle(fontWeight: FontWeight.w400, fontSize: AppSizes.fontSizeSm),
              ),
            ],
          ),
        ),
        FavoriteButton(songEntity: widget.songEntity),
      ],
    );
  }

  Widget _songPlayer(BuildContext context) {
    return BlocBuilder<SongPlayerCubit, SongPlayerState>(
      builder: (context, state) {
        if (state is SongPlayerLoading) {
          return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)));
        }
        if (state is SongPlayerLoaded) {
          final songPlayerCubit = context.read<SongPlayerCubit>();
          final songPosition = songPlayerCubit.songPosition.inSeconds.toDouble();
          final songDuration = songPlayerCubit.songDuration.inSeconds.toDouble();

          return Column(
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
                    onLongPressStart: () {
                      _startSeeking(context, isForward: false);
                    },
                    onLongPressEnd: () {
                      _stopSeeking();
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
                        color: AppColors.transparent,
                        border: Border.all(color: AppColors.lightGrey, width: 1.5),
                      ),
                      child: Icon(
                        songPlayerCubit.audioPlayer.playing ? Icons.pause : Icons.play_arrow,
                        color: AppColors.white,
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
                    onLongPressStart: () {
                      _startSeeking(context, isForward: true);
                    },
                    onLongPressEnd: () {
                      _stopSeeking();
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
    required VoidCallback onLongPressStart,
    required VoidCallback onLongPressEnd,
  }) {
    return GestureDetector(
      onTap: onTap,
      onLongPressStart: (details) => onLongPressStart(),
      onLongPressEnd: (details) => onLongPressEnd(),
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

  void _startSeeking(BuildContext context, {required bool isForward}) {
    _isForward = isForward;
    _seekTimer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      if (_isForward) {
        context.read<SongPlayerCubit>().seekForward(const Duration(seconds: 5));
      } else {
        context.read<SongPlayerCubit>().seekBackward(const Duration(seconds: 5));
      }
    });
  }

  void _stopSeeking() {
    _seekTimer?.cancel();
    _seekTimer = null;
  }

  String formatDuration(Duration duration, {bool isRemaining = false}) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    final formattedTime = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return isRemaining ? formattedTime : '-$formattedTime';
  }
}
