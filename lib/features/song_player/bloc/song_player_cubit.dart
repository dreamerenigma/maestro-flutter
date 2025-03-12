import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:maestro/features/song_player/bloc/song_player_state.dart';
import '../../../data/services/notification/notification_service.dart';
import '../../../domain/entities/song/song_entity.dart';
import '../../../utils/constants/app_urls.dart';
import '../widgets/task/audio_player_task.dart';

class SongPlayerCubit extends Cubit<SongPlayerState> {
  final AudioPlayer audioPlayer = AudioPlayer();
  final NotificationService notificationService = Get.find<NotificationService>();
  final AudioPlayerTask audioPlayerTask = Get.find<AudioPlayerTask>();
  Duration songDuration = Duration.zero;
  Duration songPosition = Duration.zero;
  bool isRepeating = false;
  SongEntity? currentSong;
  bool isPlaying = false;
  List<SongEntity> songQueue = [];
  int currentSongIndex = 0;

  SongPlayerCubit() : super(SongPlayerLoading()) {
    audioPlayer.positionStream.listen((position) {
      songPosition = position;
      updateSongPlayer();
    });

    audioPlayer.durationStream.listen((duration) {
      songDuration = duration ?? Duration.zero;
      updateSongPlayer();
    });

    audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        audioPlayer.stop();
        safeEmit(SongPlayerLoaded(currentSong));
      } else if (playerState.playing) {
        safeEmit(SongPlayerLoaded(currentSong));
      } else {
        safeEmit(SongPlayerLoaded(currentSong));
      }
    });
  }

  void updateSongPlayer() {
    safeEmit(SongPlayerLoaded(currentSong));
  }

  Future<void> loadSong(SongEntity song) async {
    try {
      if (song.fileURL.isEmpty) {
        log("The provided URL is empty!");
        throw Exception("URL is empty");
      }

      if (song.fileURL.startsWith(AppURLs.songFirestorage)) {
        log('Loading song from Firebase Storage');
      } else if (song.fileURL.startsWith(AppURLs.coverFirestorage)) {
        log('Error: URL points to a cover image, not a song file.');
        throw Exception("URL points to a cover image, not a song file.");
      } else if (!song.fileURL.startsWith('file://')) {
        log('URL does not start with "file://", assuming it is an external URL.');
      }

      await audioPlayer.setUrl(song.fileURL);
      currentSong = song;
      safeEmit(SongPlayerLoaded(currentSong));
    } catch (e) {
      log('Error loading song: $e');
      safeEmit(SongPlayerFailure('Failed to load song: $e'));
    }
  }

  Future<void> playOrPauseSong([SongEntity? song]) async {
    try {
      log('Current Position Before Action: $songPosition');
      log('Is Playing: $isPlaying');

      if (song != null) {
        log('Playing song: ${song.title}');
        String url = song.fileURL;
        log('Song URL: $url');

        if (currentSong == song && audioPlayer.playing) {
          songPosition = audioPlayer.position;
          await audioPlayer.pause();
          log('Song paused: ${song.title}');
          notificationService.showNotification('Paused: ${song.title}');
          isPlaying = false;
        } else {
          if (currentSong != null) {
            log('Stopping current song: ${currentSong?.title}');
            await audioPlayer.stop();
            songPosition = Duration.zero;
          }

          currentSong = song;

          if (!url.startsWith('http') && !url.startsWith('file://')) {
            url = 'file://$url';
          }

          if (currentSong?.fileURL != url) {
            log('Setting URL: $url');
            await audioPlayer.setUrl(url);
          }

          songPosition = Duration.zero;
          log('Seeking to position: $songPosition');
          await audioPlayer.seek(songPosition);

          if (!audioPlayer.playing) {
            await audioPlayer.play();
            log('Song started: ${song.title}');
            notificationService.showNotification('Now Playing: ${song.title}');
            isPlaying = true;
          }
        }
      } else {
        if (audioPlayer.playing) {
          songPosition = audioPlayer.position;
          await audioPlayer.pause();
          log('Song paused');
          notificationService.showNotification('Paused');
          isPlaying = false;
        } else {
          if (songPosition > Duration.zero) {
            await audioPlayer.seek(songPosition);
          }
          await audioPlayer.play();
          log('Song resumed');
          notificationService.showNotification('Now Playing');
          isPlaying = true;
        }
      }

      emit(SongPlayerLoaded(currentSong));

    } catch (e) {
      log('Error in playOrPauseSong: $e');
      emit(SongPlayerFailure('Error playing or pausing song: $e'));
    }
  }

  void setSongQueue(List<SongEntity> songs) {
    songQueue = songs;
    currentSongIndex = 0;
    loadSong(songs[currentSongIndex]);
  }

  void seekForward(Duration duration) {
    final newPosition = songPosition + duration;
    if (newPosition < songDuration) {
      audioPlayer.seek(newPosition);
    } else {
      audioPlayer.seek(songDuration);
    }
    safeEmit(SongPlayerLoaded(currentSong));
  }

  void seekBackward(Duration duration) {
    final newPosition = songPosition - duration;
    if (newPosition > Duration.zero) {
      audioPlayer.seek(newPosition);
    } else {
      audioPlayer.seek(Duration.zero);
    }
    safeEmit(SongPlayerLoaded(currentSong));
  }

  void toggleRepeat() {
    isRepeating = !isRepeating;
    updateSongPlayer();
  }

  void safeEmit(SongPlayerState state) {
    if (!isClosed) {
      emit(state);
    }
  }

  @override
  Future<void> close() {
    audioPlayer.dispose();
    return super.close();
  }
}
