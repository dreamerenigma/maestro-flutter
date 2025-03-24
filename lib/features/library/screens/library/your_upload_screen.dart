import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestro/common/widgets/app_bar/app_bar.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import 'package:maestro/routes/custom_page_route.dart';
import 'package:maestro/utils/helpers/helper_functions.dart';
import '../../../../api/apis.dart';
import '../../../../domain/entities/song/song_entity.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../home/screens/home_screen.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import '../../../home/screens/upload_tracks_screen.dart';
import '../../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../../widgets/lists/track/tracks_list.dart';

class YourUploadScreen extends StatefulWidget {
  final int initialIndex;

  const YourUploadScreen({super.key, required this.initialIndex});

  @override
  State<YourUploadScreen> createState() => YourUploadScreenState();
}

class YourUploadScreenState extends State<YourUploadScreen> {
  late final int selectedIndex;
  List<SongEntity> myTracks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });

    _fetchTracks();
  }

  Future<void> _fetchTracks() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        log('User is not authenticated');
        return;
      }

      final tracks = await APIs.fetchTracks(user.uid);

      if (mounted) {
        setState(() {
          myTracks = tracks;
        });
      }
    } catch (e) {
      log('Error fetching tracks: $e');
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
        title: const Text('Your uploads', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
        centerTitle: false,
        action: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.cast, size: 22, color: AppColors.grey),
        ),
      ),
      body: MiniPlayerManager(
        hideMiniPlayerOnSplash: false,
        child: isLoading
          ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)))
          : ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: RefreshIndicator(
              onRefresh: _reloadData,
              displacement: 0,
              color: AppColors.primary,
              backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.softGrey,
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLimitUpload(),
                      TracksList(tracks: myTracks, userData: {}, shouldShowLikesListRow: false),
                      _buildSection('Got something new to share?', 'Upload directly from your phone.'),
                    ],
                  ),
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

  Widget _buildLimitUpload() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.youngNight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(PhosphorIcons.star_four_fill, color: AppColors.purple, size: 13),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'No get heard credits',
                      style: TextStyle(fontSize: 13, color: AppColors.lightGrey), overflow: TextOverflow.ellipsis, softWrap: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.youngNight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_upload_rounded, color: AppColors.blue, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '0/180 mins used',
                      style: TextStyle(fontSize: 13, color: AppColors.lightGrey), overflow: TextOverflow.ellipsis, softWrap: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.bold)),
          Text(content, style: const TextStyle(fontSize: AppSizes.fontSizeSm, color: AppColors.lightGrey)),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, createPageRoute(UploadTracksScreen(songName: '', shouldSelectFileImmediately: true)));
                },
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all(HelperFunctions.isDarkMode(Get.context!) ? AppColors.dark : AppColors.white),
                  backgroundColor: WidgetStateProperty.all(HelperFunctions.isDarkMode(Get.context!) ? AppColors.white : AppColors.black),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                  side: WidgetStateProperty.all(const BorderSide(width: 0)),
                  padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 14)),
                  overlayColor: WidgetStateProperty.resolveWith<Color?>(
                    (states) {
                      if (states.contains(WidgetState.pressed)) {
                        return HelperFunctions.isDarkMode(Get.context!) ? AppColors.darkerGrey : AppColors.lightGrey;
                      }
                      return null;
                    },
                  ),
                ),
                child: Text('Upload tracks', style: TextStyle(color: context.isDarkMode ? AppColors.black : AppColors.white, fontSize: AppSizes.fontSizeLg)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
