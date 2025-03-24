import 'dart:io';
import 'dart:math' as math;
import 'dart:developer';
import 'package:android_intent_plus/android_intent.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:maestro/features/home/screens/inbox_screen.dart';
import 'package:maestro/features/library/widgets/dialogs/qr_code_dialog.dart';
import 'package:maestro/features/library/widgets/dialogs/show_more_bio_info_bottom_dialog.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import 'package:mono_icons/mono_icons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:typicons_flutter/typicons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../domain/entities/song/song_entity.dart';
import '../../../../domain/entities/station/station_entity.dart';
import '../../../../domain/entities/user/user_entity.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/formatters/formatter.dart';
import '../../../../utils/popups/dialogs.dart';
import '../../../search/widgets/dialogs/block_user_dialog.dart';
import '../../screens/library/station/station_screen.dart';
import '../../screens/report_screen.dart';

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

Future<void> showShareProfileDialog(
  BuildContext context,
  Map<String, dynamic> userData,
  UserEntity? userEntity, {
  required bool isStartStation,
  required bool isFollow,
  required bool isMissingMusic,
  required bool isReport,
  required bool isBlockUser,
  required Future<bool> Function(UserEntity?) checkIfBlocked,
  }) async {
  bool isUserData = userEntity == null;
  bool isBlocked = false;
  isBlocked = await checkIfBlocked(userEntity);

  final userImage = userEntity == null ? userData['image'] as String? : (userData['id'] == userEntity.id ? userData['image'] as String? : userEntity.image);
  final userName = userEntity == null ? userData['name'] as String? : (userData['id'] == userEntity.id ? userData['name'] as String? : userEntity.name);
  final trackCount = userEntity == null ? userData['tracksCount'] as int : (userData['id'] == userEntity.id ? userData['tracksCount'] as int : userEntity.tracksCount);

  int initialIndex = 0;
  int selectedIndex = 0;
  onItemTapped(index) {}
  updateUnreadMessages(index) {}

  List<UserEntity> user = [];
  List<StationEntity> station = [];
  List<SongEntity> songs = [];

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
            margin: const EdgeInsets.only(top: 10),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 20),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.darkGrey,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.darkerGrey.withAlpha((0.2 * 255).toInt()), width: 1),
                  ),
                  child: CircleAvatar(
                    maxRadius: 25,
                    backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.lightGrey,
                    backgroundImage: userImage != null && userImage.isNotEmpty ? NetworkImage(userImage) : null,
                    child: userImage == null || userImage.isEmpty ? SvgPicture.asset(AppVectors.avatar, width: 50, height: 50) : null,
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$userName', style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeMd)),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {},
                          splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                          highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                          child: Text('346 Followers', style: const TextStyle(fontSize: 13, color: AppColors.buttonGrey, fontWeight: FontWeight.w400)),
                        ),
                        const Text(' · ', style: TextStyle(fontSize: 13, color: AppColors.buttonGrey, fontWeight: FontWeight.w400)),
                        Text(Formatter.formatTrackCount(trackCount), style: const TextStyle(fontSize: 13, color: AppColors.buttonGrey, fontFamily: 'Roboto', fontWeight: FontWeight.normal)),
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
                      Dialogs.showProgressBar(context);

                      Future.delayed(const Duration(seconds: 1), () {
                        Navigator.pop(context);
                        showQrCodeDialog(context);
                      });
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
                      Dialogs.showProgressBar(context);

                      Future.delayed(const Duration(seconds: 1), () {
                        Navigator.pop(context);
                        copyUserInfo(userData);
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
                        shareContent(userData);
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
          SizedBox(height: 15),
          Divider(height: 0, thickness: 1, color: context.isDarkMode ? AppColors.darkGrey : AppColors.lightGrey),
          SizedBox(height: 6),
          if (isStartStation && !isBlocked && isUserData)
          _buildSectionOption(context, 'Start station', icon: BoxIcons.bx_station, iconSize: 24, () {
            // Navigator.pushReplacement(context, createPageRoute(StationScreen(initialIndex: initialIndex, station: station, song: songs, user: user)));
          }),
          if (isFollow && !isBlocked)
          _buildSectionOption(context, 'Follow', icon: MonoIcons.userAdd, iconSize: 24, () {
            Navigator.pop(context);
            showMoreBioInfoBottomDialog(context, userData, userEntity);
          }),
          _buildSectionOption(context, 'View info', icon: Icons.info_outline_rounded, iconSize: 24, () {
            Navigator.pop(context);
            showMoreBioInfoBottomDialog(context, userData, userEntity);
          }),
          if (isMissingMusic)
          Divider(height: 5, thickness: 1, color: context.isDarkMode ? AppColors.darkGrey : AppColors.lightGrey),
          if (isMissingMusic)
          _buildSectionOption(context, 'Request Missing Music', icon: Typicons.pencil, iconSize: 24, () {
            Navigator.pop(context);
            showMoreBioInfoBottomDialog(context, userData, userEntity);
          }),
          if (isReport)
          _buildSectionOption(context, 'Report', icon: BoxIcons.bx_station, iconSize: 24, svgIcon: SvgPicture.asset(
            AppVectors.flag,
            colorFilter: ColorFilter.mode(context.isDarkMode ? AppColors.white : AppColors.black, BlendMode.srcIn),
            width: 22,
            height: 22,
          ), () {
            Navigator.pushReplacement(context, createPageRoute(ReportScreen()));
          }),
          if (isBlockUser)
          _buildSectionOption(
            context,
            'Block user',
            icon: Icons.block_flipped,
            iconSize: 24,
            () {
              Navigator.pop(context);
              showBlockUserDialog(context, userEntity, isBlocked.obs);
            },
          ),
          SizedBox(height: 12),
        ],
      );
    }
  );
}

Widget _buildSectionOption(
  BuildContext context,
  String text,
  VoidCallback onTap,
  {IconData? icon, Widget? svgIcon, Color? iconColor, Color? textColor, double iconSize = 24}
) {
  return InkWell(
    onTap: onTap,
    splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
    highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
      child: Row(
        children: [
          if (svgIcon != null)
            svgIcon
          else if (icon != null)
            Icon(icon, color: iconColor, size: iconSize),
          if (icon != null || svgIcon != null) SizedBox(width: 16),
          Text(
            text,
            style: TextStyle(color: textColor, fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.normal),
          ),
        ],
      ),
    ),
  );
}
