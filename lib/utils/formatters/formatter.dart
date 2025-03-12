import 'package:intl/intl.dart';
import 'dart:math' as math;

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
}
