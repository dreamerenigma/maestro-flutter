import 'dart:io';
import 'dart:math' as math;
import 'dart:developer';
import 'package:android_intent_plus/android_intent.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:maestro/features/home/screens/inbox_screen.dart';
import 'package:maestro/features/library/widgets/dialogs/qr_code_dialog.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../domain/entities/song/song_entity.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/popups/dialogs.dart';

void copyUserInfo(Map<String, dynamic> userData) {
  final userName = userData['userName'] as String?;

  String randomString = generateRandomString(12);
  String textToCopy = "Check out $userName on #Maestro https://on.maestro.com/$randomString";

  Clipboard.setData(ClipboardData(text: textToCopy)).then((_) {
    log("Copied to clipboard: $textToCopy");
  });
}

String generateRandomString(int length) {
  const String chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  math.Random random = math.Random();
  return String.fromCharCodes(Iterable.generate(
    length, (_) => chars.codeUnitAt(random.nextInt(chars.length))
  ));
}

void openWhatsApp({required String phoneNumber, required String message}) async {
  final uri = Uri.parse("whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}");

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    log("Не удалось открыть WhatsApp. Возможно, оно не установлено.");
  }
}

void openSMSApp() async {
  if (Platform.isAndroid) {
    final intent = AndroidIntent(
      action: 'android.intent.action.VIEW',
      package: 'com.google.android.apps.messaging',
      componentName: 'com.google.android.apps.messaging/com.google.android.apps.messaging.ConversationListActivity',
      flags: <int>[0x10000000],
    );

    try {
      await intent.launch();
    } catch (e) {
      log("Ошибка при открытии приложения SMS: $e");
    }
  } else if (Platform.isIOS) {
    final Uri smsUri = Uri(scheme: 'sms');
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      log("Не удалось открыть приложение сообщений.");
    }
  }
}

void shareContent(Map<String, dynamic> userData) {
  final userName = userData['userName'] as String?;
  String randomString = generateRandomString(12);
  final String content = "Check out $userName on #Maestro https://on.maestro.com/$randomString";

  Share.share(content);
}

void showShareTrackBottomDialog(BuildContext context, Map<String, dynamic> userData, SongEntity song) {
  int initialIndex = 0;
  int selectedIndex = 0;
  onItemTapped(index) {}
  updateUnreadMessages(index) {}

  showModalBottomSheet(
    context: context,
    enableDrag: true,
    showDragHandle: false,
    isScrollControlled: true,
    backgroundColor: context.isDarkMode ? AppColors.backgroundColor : AppColors.lightBackground,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 5,
            width: 40,
            decoration: BoxDecoration(color: context.isDarkMode ? AppColors.white : AppColors.black, borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.only(top: 10, bottom: 6),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizes.cardRadiusXs),
                    border: Border.all(color: AppColors.darkGrey, width: 0.5),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        song.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 101),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: Text(
                          song.title,
                          style: const TextStyle(color: AppColors.white, fontSize: 15, fontWeight: FontWeight.bold, height: 1, letterSpacing: -0.5),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(song.uploadedBy, style: const TextStyle(fontSize: 13, color: AppColors.buttonGrey, fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 110,
            child: ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                itemBuilder: (context, index) {
                  List<Map<String, dynamic>> itemsData = [
                    {'icon': Icons.qr_code, 'text': 'QR code', 'onTap': () async {
                      Navigator.pop(context);
                      showQrCodeDialog(context);
                    }},
                    {'icon': CarbonIcons.send_alt, 'text': 'Message', 'onTap': () {
                      Dialogs.showProgressBar(context);

                      Future.delayed(const Duration(seconds: 1), () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(context, createPageRoute(InboxScreen(
                          initialIndex: initialIndex,
                          selectedIndex: selectedIndex,
                          onItemTapped: onItemTapped,
                          updateUnreadMessages: updateUnreadMessages,
                        )));
                      });
                    }},
                    {'icon': PhosphorIcons.copy, 'text': 'Copy link', 'onTap': () {
                      Navigator.pop(context);
                      Dialogs.showProgressBar(context);

                      Future.delayed(const Duration(seconds: 1), () {
                        Navigator.pop(context);
                        CustomIconSnackBar.showAnimatedSnackBar(
                          context,
                          'Copied to clipboard',
                          icon: const Icon(Bootstrap.clipboard2_check),
                          iconColor:AppColors.white,
                          backgroundColor: AppColors.white.withAlpha((0.1 * 255).toInt()),
                        );
                      });
                    }},
                    {'icon': Bootstrap.whatsapp, 'text': 'WhatsApp', 'onTap': () {
                      Navigator.pop(context);
                      openWhatsApp(
                        phoneNumber: '',
                        message: ''
                      );
                    }},
                    {'icon': Bootstrap.whatsapp, 'text': 'Status', 'onTap': () {
                      Navigator.pop(context);
                    }},
                    {'icon': TablerIcons.message_circle_2, 'text': 'SMS', 'onTap': () {
                      Navigator.pop(context);
                      Dialogs.showProgressBar(context);

                      Future.delayed(const Duration(seconds: 1), () {
                        Navigator.pop(context);
                        openSMSApp();
                      });
                    }},
                    {'icon': Icons.more_horiz_rounded, 'text': 'More', 'onTap': () {
                      Navigator.pop(context);
                      Dialogs.showProgressBar(context);

                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.pop(context);
                      });
                    }},
                  ];

                  Color containerColor = (index == 3 || index == 4) ? AppColors.whatsApp : AppColors.darkGrey;

                  BoxDecoration outerDecoration = BoxDecoration(
                    color: containerColor,
                    shape: BoxShape.circle,
                    border: index == 4 ? Border.all(color: AppColors.whatsApp, width: 2) : null,
                  );

                  BoxDecoration innerDecoration = BoxDecoration(
                    color: containerColor,
                    shape: BoxShape.circle,
                    border: index == 4 ? Border.all(color: AppColors.backgroundColor, width: 2) : null,
                  );

                  return InkWell(
                    onTap: itemsData[index]['onTap'],
                    splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                    highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                    borderRadius: BorderRadius.circular(AppSizes.cardRadiusXs),
                    child: Padding(
                      padding: EdgeInsets.only(left: 14, right: 14, top: 12, bottom: 12),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 58,
                                height: 58,
                                decoration: outerDecoration,
                                child: Container(
                                  width: 56,
                                  height: 56,
                                  decoration: innerDecoration,
                                  child: Icon(itemsData[index]['icon'], color: AppColors.white, size: 32),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(itemsData[index]['text'], style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );
    },
  );
}
