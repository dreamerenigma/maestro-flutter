import 'dart:developer';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

Future<void> fetchAndShowUserInfo(BuildContext context, String userId) async {
  try {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(userId).get();

    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      final userLinks = (userData['links'] as List).map((link) {
        if (link is Map<String, dynamic>) {
          return {
            'title': link['title'] ?? '',
            'url': link['webOrEmail'] ?? '',
          };
        }
        return {};
      }).toList();

      userData['links'] = userLinks;

      showMoreBioInfoBottomDialog(context, userData);
    } else {
      log("User not found");
    }
  } catch (e) {
    log("Error fetching user data: $e");
  }
}

void showMoreBioInfoBottomDialog(BuildContext context, Map<String, dynamic> userData) {
  final userBioInfo = userData['bio'] as String?;
  final userLinks = (userData['links'] as List<dynamic>?)
    ?.map((link) {
      if (link is Map<String, dynamic>) {
        return {
          'title': link['title'] ?? '',
          'url': link['webOrEmail'] ?? '',
        };
      }
      return <String, String>{};
    }).toList() ?? [];

  final Map<String, IconData> domainIcons = {
      'google.com': BootstrapIcons.google,
      'youtube.com': BootstrapIcons.youtube,
      'facebook.com': BootstrapIcons.facebook,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('Bio', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: -0.3)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                child: Text('$userBioInfo', style: TextStyle(fontSize: AppSizes.fontSizeMd, color: AppColors.grey, letterSpacing: -0.3)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text('Links', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: -0.3)),
              ),
              for (var link in userLinks)
                _buildLinkRow(
                  icon: getIconForLink(link['url'] ?? ''),
                  text: link['title'] ?? '',
                  onTap: () {
                    log('Opening link: ${link['url']}');
                  }
                ),
              const SizedBox(height: 16),
            ],
          ),
        ],
      );
    },
  );
}

Widget _buildLinkRow({
  required Widget icon,
  required String text,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
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
