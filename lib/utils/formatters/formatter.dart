import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'package:timeago/timeago.dart' as timeago;

class Formatter {
  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat('dd-MMM-yyyy').format(date);
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'en_US', symbol: '\$').format(amount);
  }

  static String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length == 10) {
      return '(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)} ${phoneNumber.substring(6)}';
    } else if (phoneNumber.length == 11) {
      return '(${phoneNumber.substring(0, 4)}) ${phoneNumber.substring(4, 7)} ${phoneNumber.substring(7)}';
    }
    return phoneNumber;
  }

  static String internationalFormatPhoneNumber(String phoneNumber) {
    var digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');

    String countryCode = '+${digitsOnly.substring(0, 2)}';
    digitsOnly = digitsOnly.substring(2);

    final formattedNumber = StringBuffer();
    formattedNumber.write('($countryCode) ');

    int i = 0;
    while (i < digitsOnly.length) {
      int groupLength = 2;
      if (i == 0 && countryCode == '+1') {
        groupLength = 3;
      }

      int end = i + groupLength;
      formattedNumber.write(digitsOnly.substring(i, end));

      if (end < digitsOnly.length) {
        formattedNumber.write(' ');
      }
      i = end;
    }

    return formattedNumber.toString();
  }

  static String formatTrackCount(int count) {
    const List<String> words = [
      "One", "Two", "Three", "Four", "Five",
      "Six", "Seven", "Eight", "Nine", "Ten"
    ];

    if (count >= 1 && count <= 10) {
      return '${words[count - 1]} ${count == 1 ? 'Track' : 'Tracks'}';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}K Tracks';
    } else {
      return '$count Tracks';
    }
  }

  static String formatFileSize(int sizeInBytes) {
    if (sizeInBytes <= 0) return "0 B";
    const sizes = ['B', 'KB', 'MB', 'GB', 'TB'];
    int index = (math.log(sizeInBytes) /  math.log(1024)).floor();
    double size = sizeInBytes /  math.pow(1024, index);
    return '${size.toStringAsFixed(2)} ${sizes[index]}';
  }

  static String formatDateAudio(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  static String formatDuration(Duration duration, {bool isRemaining = false}) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    final formattedTime = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    return isRemaining ? formattedTime : '-$formattedTime';
  }

  static String formatTrackPosition(double trackPosition) {
    int minutes = trackPosition.floor();
    int seconds = ((trackPosition - minutes) * 60).round();
    return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  static String formatReleaseDate(dynamic releaseDate) {
    if (releaseDate != null && releaseDate is Timestamp) {
      try {
        final date = releaseDate.toDate();
        timeago.setLocaleMessages('ru_short', timeago.RuShortMessages());
        return '${timeago.format(date, locale: 'ru_short')} назад';
      } catch (e) {
        return 'Invalid date format';
      }
    } else {
      return 'Date not available';
    }
  }

  static String formatDurationTrack(int durationInSeconds) {
    int minutes = durationInSeconds ~/ 60;
    int seconds = durationInSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  static String formatTimeAgo(DateTime dateTime) {
    Duration diff = DateTime.now().difference(dateTime);

    if (diff.inMinutes < 1) return 'только что';

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} ${_getMinutesText(diff.inMinutes)} назад';
    }

    if (diff.inHours < 24) {
      return '${diff.inHours} ${_getHoursText(diff.inHours)} назад';
    }

    return '${diff.inDays} ${_getDaysText(diff.inDays)} назад';
  }

  static String _getMinutesText(int minutes) {
    if (minutes == 1) return 'минуту';
    if (minutes >= 2 && minutes <= 4) return 'минуты';
    return 'минут';
  }

  static String _getHoursText(int hours) {
    if (hours == 1) return 'час';
    if (hours >= 2 && hours <= 4) return 'часа';
    return 'часов';
  }

  static String _getDaysText(int days) {
    if (days == 1) return 'день';
    if (days >= 2 && days <= 4) return 'дня';
    return 'дней';
  }

  static String formatTime(DateTime dateTime) {
    final currentTime = DateTime.now();
    final difference = currentTime.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} h';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} d';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} m';
    } else {
      return '${(difference.inDays / 365).floor()} y';
    }
  }

  static int parseDuration(String durationString) {
    final parts = durationString.split(':');
    if (parts.length == 2) {
      final minutes = int.tryParse(parts[0]) ?? 0;
      final seconds = int.tryParse(parts[1]) ?? 0;
      return minutes * 60 + seconds;
    }
    return 0;
  }
}
