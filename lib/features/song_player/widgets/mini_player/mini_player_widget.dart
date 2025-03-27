import 'dart:async';
import 'dart:developer';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/iconoir.dart';
import 'package:ionicons/ionicons.dart';
import 'package:maestro/features/song_player/screens/song_player_screen.dart';
import 'package:maestro/routes/custom_page_route.dart';
import '../../../../common/widgets/buttons/favorite_button.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../sliders/mini_player_slider.dart';
import '../../bloc/song_player_cubit.dart';
import '../../bloc/song_player_state.dart';

class MiniPlayerWidget extends StatefulWidget {
  final void Function(int) onItemTapped;

  const MiniPlayerWidget({super.key, required this.onItemTapped});

  @override
  State<MiniPlayerWidget> createState() => _MiniPlayerWidgetState();
}

class _MiniPlayerWidgetState extends State<MiniPlayerWidget> {
  bool _isPressed = false;
  int selectedIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
  }

  String? _getArtistFromTitle(String? title) {
    if (title != null && title.contains('-')) {
      final parts = title.split('-');
      return parts[0].trim();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return _buildWebPlayer(context);
    } else {
      return _buildMobilePlayer(context);
    }
  }

  Widget _buildMobilePlayer(BuildContext context) {
    return BlocBuilder<SongPlayerCubit, SongPlayerState>(
      builder: (context, state) {
        if (state is SongPlayerLoaded) {
          final songPlayerCubit = context.read<SongPlayerCubit>();
          final songEntity = context.read<SongPlayerCubit>().currentSong;

          if (songEntity == null) {
            return Container();
          }
          final isPlaying = context.read<SongPlayerCubit>().audioPlayer.playing;
          log('Audio player playing: $isPlaying');
          final currentPosition = context.read<SongPlayerCubit>().songPosition;
          final totalDuration = context.read<SongPlayerCubit>().songDuration;
          final progress = totalDuration.inMilliseconds > 0 ? currentPosition.inMilliseconds / totalDuration.inMilliseconds : 0.0;
          final fileURL = songEntity.fileURL;
          final isLocalFile = fileURL.startsWith('file://') || fileURL.startsWith('/');

          if (isPlaying && _timer == null) {
            _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
              setState(() {});
            });
          } else if (!isPlaying && _timer != null) {
            _timer?.cancel();
          }

          log('Song Entity: ${songEntity.title}, isPlaying: $isPlaying, currentPosition: $currentPosition, totalDuration: $totalDuration');

          final user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            log('No user logged in');
            throw Exception('No user logged in');
          }

          final isSongUploadedByCurrentUser = songEntity.uploadedBy == user.uid;

          return Container(
            height: 60,
            decoration: BoxDecoration(
              color: context.isDarkMode ? AppColors.blackGrey : AppColors.darkerGrey,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(AppSizes.cardRadiusBg), topRight: Radius.circular(AppSizes.cardRadiusBg)),
            ),
            child: Material(
              color: AppColors.transparent,
              child: InkWell(
                onTap: () {
                  final songEntity = context.read<SongPlayerCubit>().currentSong;
                  log('Tapped song: ${songEntity?.title ?? 'No song available'}');
                  if (songEntity != null) {
                    Navigator.push(context, createPageRoute(SongPlayerScreen(song: songEntity, isPlaying: context.read<SongPlayerCubit>().isPlaying, initialIndex: selectedIndex)));
                  } else {
                    log('No song available');
                  }
                },
                splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(AppSizes.cardRadiusBg), topRight: Radius.circular(AppSizes.cardRadiusBg)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 14, right: 8, top: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.grey, border: Border.all(color: AppColors.buttonDarkGrey, width: 1)),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      ClipOval(
                                        child: Image.asset(
                                          AppImages.defaultCover1,
                                          width: 42,
                                          height: 42,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Container(
                                        width: 9,
                                        height: 9,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.blackGrey,
                                          border: Border.all(color: AppColors.buttonDarkGrey, width: 0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        songEntity.title.split('.').first,
                                        style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        songEntity.uploadedBy.isNotEmpty == true
                                          ? songEntity.uploadedBy
                                          : (songEntity.artist.isNotEmpty == true && songEntity.artist != '<unknown>')
                                            ? songEntity.artist
                                            : _getArtistFromTitle(songEntity.title) ?? 'Unknown Artist',
                                        style: const TextStyle(color: AppColors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: AppColors.white, size: 30),
                                onPressed: () {
                                  log('Play/Pause button pressed');
                                  songPlayerCubit.playOrPauseSong();
                                },
                              ),
                              if (!isLocalFile) ...[
                                if (isSongUploadedByCurrentUser) ...[
                                  IconButton(
                                    icon: const Icon(Icons.person_add_alt, color: AppColors.white),
                                    onPressed: () {},
                                  ),
                                ],
                                SizedBox(width: 6),
                                FavoriteButton(songEntity: songEntity, showLikeCount: false),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: AppColors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                          minHeight: 1,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildWebPlayer(BuildContext context) {
    return BlocBuilder<SongPlayerCubit, SongPlayerState>(
      builder: (context, state) {
        if (state is SongPlayerLoaded) {
          final isPlaying = context.read<SongPlayerCubit>().audioPlayer.playing;
          final songEntity = context.read<SongPlayerCubit>().currentSong;

          return Container(
            height: 70,
            decoration: BoxDecoration(
              color: context.isDarkMode ? AppColors.lightGrey : AppColors.blackGrey,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 100),
                      IconButton(
                        icon: Icon(Icons.skip_previous, color: context.isDarkMode ? AppColors.white : AppColors.black, size: 22),
                        onPressed: () {},
                      ),
                      SizedBox(width: 5),
                      IconButton(
                        icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: AppColors.white, size: 22),
                        onPressed: () {
                          context.read<SongPlayerCubit>().playOrPauseSong(songEntity);
                        },
                      ),
                      SizedBox(width: 5),
                      IconButton(
                        icon: Icon(Icons.skip_next, color: context.isDarkMode ? AppColors.white : AppColors.black, size: 22),
                        onPressed: () {},
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        icon: Icon(
                          Ionicons.shuffle_outline,
                          color: _isPressed ? AppColors.primary : (context.isDarkMode ? AppColors.white : AppColors.black),
                          size: 22,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPressed = !_isPressed;
                          });
                        },
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        icon: Iconify(Iconoir.repeat, color: context.isDarkMode ? AppColors.white : AppColors.black, size: 22),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 30),
                Expanded(child: MiniPlayerSlider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.grey,
                          border: Border.all(color: AppColors.buttonDarkGrey, width: 1),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            AppImages.playlist,
                            width: 42,
                            height: 42,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(songEntity?.title ?? 'Unknown Title', style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
                          Text(songEntity?.artist ?? 'Unknown Artist', style: const TextStyle(color: AppColors.white)),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.favorite_outline_outlined, color: AppColors.white, size: 22),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.person_add_alt_1_sharp, color: AppColors.white, size: 22),
                        onPressed: () {
                          context.read<SongPlayerCubit>().playOrPauseSong(songEntity);
                        },
                      ),
                      IconButton(
                        icon: Icon(CarbonIcons.playlist, color: AppColors.white, size: 22),
                        onPressed: () {
                          context.read<SongPlayerCubit>().playOrPauseSong(songEntity);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 100),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
