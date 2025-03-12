import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../data/services/notification/notification_service.dart';
import '../../../../domain/entities/song/song_entity.dart';

class AudioPlayerTask extends BaseAudioHandler {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final NotificationService _notificationService = NotificationService();
  SongEntity? currentSong;

  final BehaviorSubject<PlaybackState> _playbackStateController = BehaviorSubject<PlaybackState>();

  Future<void> onStart(Map<String, dynamic>? params) async {
    final String url = params?['url'] ?? '';
    await _audioPlayer.setUrl(url);
    await _audioPlayer.play();

    _playbackStateController.add(PlaybackState(
      controls: [
        MediaControl.play,
        MediaControl.pause,
        MediaControl.stop,
      ],
      processingState: AudioProcessingState.ready,
      playing: true,
      updatePosition: _audioPlayer.position,
      bufferedPosition: _audioPlayer.bufferedPosition,
      speed: 1.0,
    ));

    _notificationService.showNotification(currentSong?.title ?? "Song Title");
  }

  @override
  Future<void> stop() async {
    super.stop();
    await _audioPlayer.stop();
    await _playbackStateController.close();
    _notificationService.cancelNotification();
  }

  Future<void> onPlayPause() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
      _playbackStateController.add(PlaybackState(
        controls: [
          MediaControl.play,
          MediaControl.pause,
          MediaControl.stop,
        ],
        processingState: AudioProcessingState.ready,
        playing: false,
        updatePosition: _audioPlayer.position,
        bufferedPosition: _audioPlayer.bufferedPosition,
        speed: 1.0,
      ));

      _notificationService.showNotification(currentSong?.title ?? "Song Title");
    } else {
      await _audioPlayer.play();
      _playbackStateController.add(PlaybackState(
        controls: [
          MediaControl.play,
          MediaControl.pause,
          MediaControl.stop,
        ],
        processingState: AudioProcessingState.ready,
        playing: true,
        updatePosition: _audioPlayer.position,
        bufferedPosition: _audioPlayer.bufferedPosition,
        speed: 1.0,
      ));

      _notificationService.showNotification(currentSong?.title ?? "Song Title");
    }
  }

  Future<void> onSeekTo(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> onSkip() async {
    _notificationService.showNotification(currentSong?.title ?? "Song Title");
  }

  Future<void> onClick(MediaButton button) async {}

  @override
  BehaviorSubject<PlaybackState> get playbackState => _playbackStateController;
}
