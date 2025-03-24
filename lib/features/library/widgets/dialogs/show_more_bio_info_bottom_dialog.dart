import 'dart:developer';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../domain/entities/user/user_entity.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

void fetchAndShowUserInfo(BuildContext context, String userId, UserEntity? user) async {
  try {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(userId).get();

    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      final userLinks = user == null
  ? (userData['links'] as List?)?.map((link) {
      if (link is Map<String, dynamic>) {
        return {
          'title': link['title'] ?? '',
          'url': link['webOrEmail'] ?? '',
        };
      }
      return {};
    }).toList() ?? []
  : (userData['id'] == user.id ? (userData['links'] as List?)?.toList() : user.links)?.toList() ?? [];

      log('Fetched user links: $userLinks');

      userData['links'] = userLinks;

      if (user == null) {
        log('User is null, cannot fetch bio.');
        showMoreBioInfoBottomDialog(context, userData, null);
      } else {
        if (user.id == userId) {
          showMoreBioInfoBottomDialog(context, userData, user);
        } else {
          showMoreBioInfoBottomDialog(context, userData, null);
        }
      }
    } else {
      log("User not found");
    }
  } catch (e) {
    log("Error fetching user data: $e");
  }
}

void showMoreBioInfoBottomDialog(BuildContext context, Map<String, dynamic> userData, UserEntity? user) {
  log('userData[id]: ${userData['id']}');
  log('user?.id: ${user?.id}');

  final userBioInfo = user == null ? userData['bio'] as String? : (userData['id'] == user.id ? userData['bio'] as String? : user.bio);

  log('userBioInfo: $userBioInfo');

  final userLinks = user == null
  ? (userData['links'] as List?)?.map((link) {
      if (link is Map<String, dynamic>) {
        return {
          'title': link['title'] ?? '',
          'url': link['webOrEmail'] ?? '',
        };
      }
      return {};
    }).toList() ?? []
  : (userData['id'] == user.id ? (userData['links'] as List?)?.toList() : user.links)?.toList() ?? [];

  final displayBio = userBioInfo ?? 'Bio not specified';
  log('displayBio: $displayBio');
  log('userLinks: $userLinks');

  final Map<String, IconData> domainIcons = {
    'google.com': BootstrapIcons.google,
    'instagram.com': BootstrapIcons.instagram,
    'youtube.com': BootstrapIcons.youtube,
    'facebook.com': BootstrapIcons.facebook,
    'x.com': BootstrapIcons.twitter_x,
    'vk.com': FontAwesome.vk_brand,
  };

  String getDomainFromUrl(String url) {
    try {
      Uri uri = Uri.parse(url);
      return uri.host.toLowerCase();
    } catch (e) {
      return '';
    }
  }

  Widget getIconForLink(String url) {
    String domain = getDomainFromUrl(url);

    if (domainIcons.containsKey(domain)) {
      return Icon(domainIcons[domain], color: AppColors.lightGrey, size: 26);
    } else {
      return Icon(FontAwesome.earth_europe_solid, color: AppColors.lightGrey, size: 26);
    }
  }

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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 36,
                  child: CircleAvatar(
                    backgroundColor: AppColors.darkGrey,
                    child: IconButton(
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: const Icon(Icons.close, color: AppColors.white, size: 23),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Text('Info', style: TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.bold, letterSpacing: -0.3)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Bio', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: -0.3)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: Text(displayBio, style: TextStyle(fontSize: AppSizes.fontSizeMd, color: AppColors.grey, letterSpacing: -0.3)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Text('Links', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: -0.3)),
                ),
                if (userLinks.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Links not specified', style: TextStyle(fontSize: 15, color: AppColors.grey, letterSpacing: -0.3)),
                ),
                if (userLinks.isNotEmpty)
                for (var link in userLinks)
                  _buildLinkRow(
                    icon: getIconForLink(link['url'] ?? ''),
                    text: link['title'] ?? '',
                    url: link['url'] ?? '',
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      );
    },
  );
}

Widget _buildLinkRow({
  required Widget icon,
  required String text,
  required String url,
}) {
  return InkWell(
    onTap: () async {
      Uri uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Uri webUri = Uri.parse(_convertToWebUrl(url));
        if (await canLaunchUrl(webUri)) {
          await launchUrl(webUri, mode: LaunchMode.externalApplication);
        } else {
          log('Could not launch $url');
          Get.snackbar('Error', 'Could not open link');
        }
      }
    },
    splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
    highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 16),
          Text(text, style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w200)),
        ],
      ),
    ),
  );
}

String _convertToWebUrl(String url) {
  Uri uri = Uri.parse(url);

  if (uri.host.contains('youtube.com') || uri.host.contains('youtu.be')) {
    return 'https://www.youtube.com/watch?v=${uri.queryParameters["v"] ?? ""}';
  } else if (uri.host.contains('vk.com')) {
    return 'https://vk.com/${uri.path}';
  }

  return url;
}

