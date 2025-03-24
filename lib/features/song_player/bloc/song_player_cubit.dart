import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:maestro/features/song_player/bloc/song_player_state.dart';
import '../../../data/services/history/history_firebase_service.dart';
import '../../../data/services/notification/notification_service.dart';
import '../../../domain/entities/song/song_entity.dart';
import '../../../service_locator.dart';
import '../../../utils/constants/app_urls.dart';
import '../widgets/task/audio_player_task.dart';

class SongPlayerCubit extends Cubit<SongPlayerState> {
  final AudioPlayer audioPlayer = AudioPlayer();
  final NotificationService notificationService = Get.find<NotificationService>();
  final AudioPlayerTask audioPlayerTask = Get.find<AudioPlayerTask>();
  Duration songDuration = Duration.zero;
  Duration songPosition = Duration.zero;
  List<Map<String, dynamic>> listeningHistory = [];
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
        safeEmit(SongPlayerLoaded(currentSong, listeningHistory));
      } else if (playerState.playing) {
        safeEmit(SongPlayerLoaded(currentSong, listeningHistory));
      } else {
        safeEmit(SongPlayerLoaded(currentSong, listeningHistory));
      }
    });
  }

  void _loadListeningHistory() async {
    log('Loading listening history...');
    if (currentSong != null) {
      final trackData = {
        'title': currentSong!.title,
        'artist': currentSong!.artist,
        'cover': currentSong!.cover,
        'uploadedBy': currentSong!.uploadedBy,
        'duration': currentSong!.duration,
        'listenCount': currentSong!.listenCount,
        'fileURL': currentSong!.fileURL,
        'likeCount': currentSong!.likeCount,
      };

      log('Track data: $trackData');

      try {
        await sl<HistoryFirebaseService>().addToListeningHistory(trackData);
        log('Track added successfully.');

        List<Map<String, dynamic>> history = await sl<HistoryFirebaseService>().fetchListeningHistory();

        if (history.isNotEmpty) {
          log('Fetched listening history: $history');
        } else {
          log('No history found.');
        }

        listeningHistory = history;
        emit(SongPlayerLoaded(currentSong, listeningHistory));
      } catch (e) {
        log('Error loading listening history: $e');
      }
    } else {
      log('Current song is null.');
    }
  }

  void updateSongPlayer() {
    safeEmit(SongPlayerLoaded(currentSong, listeningHistory));
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
      safeEmit(SongPlayerLoaded(currentSong, listeningHistory));
    } catch (e) {
      log('Error loading song: $e');
      safeEmit(SongPlayerFailure('Failed to load song: $e'));
    }
  }

  Future<void> playSong([SongEntity? song]) async {
    try {
      if (currentSong == null) {
        log('No song loaded');
        emit(SongPlayerFailure('No song loaded'));
        return;
      }

      String url = currentSong!.fileURL;

      if (!url.startsWith('http') && !url.startsWith('file://')) {
        url = 'file://$url';
      }

      if (currentSong?.fileURL != url) {
        log('Setting URL: $url');
        await audioPlayer.setUrl(url);
      }

      if (!audioPlayer.playing) {
        songPosition = audioPlayer.position;
        await audioPlayer.seek(songPosition);
        await audioPlayer.play();
        log('Song started: ${currentSong?.title}');
        notificationService.showNotification('Now Playing: ${currentSong?.title}');
        isPlaying = true;
      }
    } catch (e) {
      log('Error in playSong: $e');
      emit(SongPlayerFailure('Error playing song: $e'));
    }
  }

  Future<void> playOrPauseSong([SongEntity? song]) async {
    try {
      if (song != null) {
        String url = song.fileURL;

        log('Attempting to play song: ${song.title}, currentSong: $currentSong, audioPlayer playing: ${audioPlayer.playing}');

        if (currentSong == song && audioPlayer.playing) {
          songPosition = audioPlayer.position;
          log('Pausing song: ${song.title}');
          await audioPlayer.pause();
          notificationService.showNotification('Paused: ${song.title}');
          isPlaying = false;
        } else {
          if (currentSong != null) {
            log('Stopping previous song: ${currentSong?.title}');
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
            log('URL set successfully, checking player status...');
            log('Audio player playing: ${audioPlayer.playing}');
          }

          songPosition = Duration.zero;
          await audioPlayer.seek(songPosition);
          log('Seeked to position: $songPosition');

          if (!audioPlayer.playing) {
            log('Starting playback for song: ${song.title}');
            await audioPlayer.play();
            log('Song started: ${song.title}');
            notificationService.showNotification('Now Playing: ${song.title}');
            isPlaying = true;

            if (!url.startsWith('file://')) {
              _loadListeningHistory();
            }
          }
        }
      } else {
        if (audioPlayer.playing) {
          log('Pausing current song...');
          songPosition = audioPlayer.position;
          await audioPlayer.pause();
          notificationService.showNotification('Paused');
          isPlaying = false;
        } else {
          log('Playing song from position: $songPosition');
          if (songPosition > Duration.zero) {
            await audioPlayer.seek(songPosition);
          }
          await audioPlayer.play();
          notificationService.showNotification('Now Playing');
          isPlaying = true;
        }
      }

      log('Emitting SongPlayerLoaded with currentSong: $currentSong');
      emit(SongPlayerLoaded(currentSong, listeningHistory));

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
    safeEmit(SongPlayerLoaded(currentSong, listeningHistory));
  }

  void seekBackward(Duration duration) {
    final newPosition = songPosition - duration;
    if (newPosition > Duration.zero) {
      audioPlayer.seek(newPosition);
    } else {
      audioPlayer.seek(Duration.zero);
    }
    safeEmit(SongPlayerLoaded(currentSong, listeningHistory));
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
