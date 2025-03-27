import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../utils/constants/app_vectors.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: null);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String songTitle, {bool isPlaying = false}) async {
    final AndroidBitmap<Object> playIcon = DrawableResourceAndroidBitmap(AppVectors.play) as AndroidBitmap<Object>;
    final AndroidBitmap<Object> pauseIcon = DrawableResourceAndroidBitmap(AppVectors.pause) as AndroidBitmap<Object>;
    final AndroidBitmap<Object> skipIcon = DrawableResourceAndroidBitmap(AppVectors.nextPlay) as AndroidBitmap<Object>;
    final AndroidBitmap<Object> favoriteIcon = DrawableResourceAndroidBitmap(AppVectors.favoriteInline) as AndroidBitmap<Object>;

    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'music_channel',
      'Music Playback',
      channelDescription: 'Channel for music playback notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: false,
      enableLights: true,
      visibility: NotificationVisibility.public,
      styleInformation: const MediaStyleInformation(),
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'play_pause',
          isPlaying ? 'Pause' : 'Play',
          icon: isPlaying ? pauseIcon : playIcon,
        ),
        AndroidNotificationAction(
          'skip',
          'Skip',
          icon: skipIcon,
        ),
        AndroidNotificationAction(
          'favorite',
          'Favorite',
          icon: favoriteIcon,
        ),
      ],
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      songTitle,
      'Playing...',
      platformChannelSpecifics,
    );
  }

  Future<void> cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancel(0);
  }

  Future<void> onNotificationAction(String? payload) async {
    if (payload == 'play_pause') {
      await _flutterLocalNotificationsPlugin.show(
        0,
        "Song Title",
        'Playing...',
        NotificationDetails(
          android: AndroidNotificationDetails(
            'music_channel',
            'Music Playback',
            channelDescription: 'Channel for music playback notifications',
            importance: Importance.high,
            priority: Priority.high,
            playSound: false,
            enableLights: true,
            visibility: NotificationVisibility.public,
            styleInformation: const MediaStyleInformation(),
            actions: <AndroidNotificationAction>[
              AndroidNotificationAction(
                'play_pause',
                'Play',
                icon: DrawableResourceAndroidBitmap(AppVectors.play) as AndroidBitmap<Object>,
              ),
              AndroidNotificationAction(
                'skip',
                'Skip',
                icon: DrawableResourceAndroidBitmap(AppVectors.nextPlay) as AndroidBitmap<Object>,
              ),
              AndroidNotificationAction(
                'favorite',
                'Favorite',
                icon: DrawableResourceAndroidBitmap(AppVectors.favoriteInline) as AndroidBitmap<Object>,
              ),
            ],
          ),
        ),
      );
    } else if (payload == 'skip') {

    } else if (payload == 'favorite') {

    }
  }
}
