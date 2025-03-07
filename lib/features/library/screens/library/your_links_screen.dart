import 'dart:developer';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import 'package:mono_icons/mono_icons.dart';
import '../../../../common/widgets/app_bar/app_bar.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../home/screens/home_screen.dart';
import '../../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../../widgets/dialogs/add_your_link_bottom_dialog.dart';

class YourLinksScreen extends StatefulWidget {
  final List<Map<String, String>> links;
  final int initialIndex;
  final Function(List<Map<String, String>>) onLinksUpdated;

  const YourLinksScreen({super.key, required this.initialIndex, required this.links, required this.onLinksUpdated});

  @override
  State<YourLinksScreen> createState() => _YourLinksScreenState();
}

class _YourLinksScreenState extends State<YourLinksScreen> {
  late final int selectedIndex;
  List<Map<String, String>> links = [];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    _loadLinks();
  }

  void _saveLinks() async {
    final List<Map<String, String>> savedLinks = List.from(links);

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        log("No user is logged in.");
        return;
      }

      final userRef = FirebaseFirestore.instance.collection('Users').doc(user.uid);

      final docSnapshot = await userRef.get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data['links'] != null) {
          List<dynamic> linkData = data['links'];

          for (var link in linkData) {
            final linkMap = Map<String, String>.from(link);
            if (!savedLinks.any((savedLink) => savedLink['webOrEmail'] == linkMap['webOrEmail'] && savedLink['title'] == linkMap['title'])) {
              await _removeLinkFromFirestore(linkMap);
            }
          }

          await userRef.update({
            'links': savedLinks,
          });
        }
      } else {
        log("User document does not exist.");
      }
      widget.onLinksUpdated(savedLinks);
    } catch (e) {
      log("Error saving links: $e");
    }
  }

  void _loadLinks() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        log("No user is logged in.");
        return;
      }

      final userRef = FirebaseFirestore.instance.collection('Users').doc(user.uid);
      final docSnapshot = await userRef.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data['links'] != null) {
          List<dynamic> linkData = data['links'];

          setState(() {
            links = linkData.map((link) {
              return Map<String, String>.from(link as Map<String, dynamic>);
            }).toList();
          });
        }
      }
    } catch (e) {
      log("Error loading links: $e");
    }
  }

  Future<void> _removeLinkFromFirestore(Map<String, String> link) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      log("No user is logged in.");
      return;
    }

    final userRef = FirebaseFirestore.instance.collection('Users').doc(user.uid);

    final docSnapshot = await userRef.get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      if (data != null && data['links'] != null) {
        List<dynamic> linkData = data['links'];

        linkData.removeWhere((existingLink) {
          return existingLink['webOrEmail'] == link['webOrEmail'] && existingLink['title'] == link['title'];
        });

        await userRef.update({'links': linkData});
      }
    }
  } catch (e) {
    log("Error removing link from Firestore: $e");
  }
}

  Future<void> _reloadData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: const Text('Your links', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
        centerTitle: false,
        saveButtonText: 'Save',
        onSavePressed: _saveLinks,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cast, size: 22, color: AppColors.grey),
          ),
        ],
      ),
      body: MiniPlayerManager(
        hideMiniPlayerOnSplash: false,
        child: ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: RefreshIndicator(
            onRefresh: _reloadData,
            displacement: 0,
            color: AppColors.primary,
            backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.softGrey,
            child: Column(
              children: [
                SizedBox(height: 12),
                _buildAddLink(context),
                SizedBox(height: 20),
                _buildLinkList(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: (index) {
          Navigator.pushReplacement(context, createPageRoute(HomeScreen(initialIndex: index)));
        },
      ),
    );
  }

  Widget _buildAddLink(BuildContext context) {
    return InkWell(
      onTap: () {
        showAddYourLinksDialog(context, (webOrEmail, title) {
          setState(() {
            links.add({
              'webOrEmail': webOrEmail,
              'title': title,
            });
          });
        });
      },
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 14, bottom: 14),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: AppColors.steelGrey,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(Icons.add_circle_outline, color: AppColors.lightGrey, size: 30),
              ),
            ),
            SizedBox(width: 16.0),
            Text('Add link', style: TextStyle(color: AppColors.white, fontSize: 18.0)),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkList() {
    return Expanded(
      child: ListView.builder(
        itemCount: links.length,
        itemBuilder: (context, index) {
          final link = links[index];
          return Padding(
            padding: EdgeInsets.only(top: index == 0 ? 0 : 8.0),
            child: _buildLinkItem(link),
          );
        },
      ),
    );
  }


  Widget _buildLinkItem(Map<String, String> link) {
    final Map<String, IconData> domainIcons = {
      'google.com': BootstrapIcons.google,
      'youtube.com': BootstrapIcons.youtube,
      'facebook.com': BootstrapIcons.facebook,
      'vk.com': FontAwesome.vk_brand,
    };

    String getDomainFromUrl(String url) {
      Uri uri = Uri.parse(url);
      return uri.host.toLowerCase();
    }

    Widget getIconForLink(String url) {
      String domain = getDomainFromUrl(url);

      if (domainIcons.containsKey(domain)) {
        return Icon(domainIcons[domain], color: AppColors.lightGrey, size: 30);
      } else {
        return Icon(FontAwesome.earth_europe_solid, color: AppColors.lightGrey, size: 30);
      }
    }

    return InkWell(
      onTap: () {},
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8.0),
        child: Row(
          children: [
            getIconForLink(link['webOrEmail']!),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    link['webOrEmail']!,
                    style: TextStyle(color: AppColors.white, fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    link['title']!,
                    style: TextStyle(color: AppColors.white, fontSize: AppSizes.fontSizeSm),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                setState(() {
                  links.remove(link);
                });
              },
              icon: Icon(MonoIcons.delete, size: 25),
            ),
          ],
        ),
      ),
    );
  }
}
