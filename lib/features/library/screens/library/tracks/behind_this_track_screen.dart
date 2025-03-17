import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestro/features/library/screens/library/tracks/widgets/track_action_icons_widget.dart';
import 'package:maestro/features/library/screens/library/tracks/widgets/track_widget.dart';
import 'package:maestro/features/song_player/widgets/mini_player/mini_player_manager.dart';
import '../../../../../api/apis.dart';
import '../../../../../common/widgets/app_bar/app_bar.dart';
import '../../../../../domain/entities/song/song_entity.dart';
import '../../../../../routes/custom_page_route.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_sizes.dart';
import '../../../../home/screens/home_screen.dart';
import '../../../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../../widgets/dialogs/more_description_bottom_dialog.dart';
import '../../../widgets/user_info_widget.dart';
import '../../profile/widgets/image_dialog.dart';
import '../../profile_settings_screen.dart';

class BehindThisTrackScreen extends StatefulWidget {
  final SongEntity song;
  final int initialIndex;

  const BehindThisTrackScreen({super.key, required this.song, required this.initialIndex});

  @override
  State<BehindThisTrackScreen> createState() => _BehindThisTrackScreenState();
}

class _BehindThisTrackScreenState extends State<BehindThisTrackScreen> {
  late Future<Map<String, dynamic>?> userDataFuture;
  late final int selectedIndex;

  @override
  void initState() {
    super.initState();
    userDataFuture = APIs.fetchUserData();
    selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.cast, size: 23, color: AppColors.lightGrey),
          ),
        ],
      ),
      body: MiniPlayerManager(
        hideMiniPlayerOnSplash: false,
        child: FutureBuilder<Map<String, dynamic>?>(
          future: userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data available'));
            }
            final userData = snapshot.data!;
            final song = widget.song;

            return Column(
              children: [
                TrackWidget(
                  song: song,
                  userData: userData,
                  onImageTap: () {
                    showImageDialog(context, song.cover, shape: BoxShape.rectangle);
                  },
                  initialIndex: widget.initialIndex,
                ),
                TrackActionIconsWidget(song: widget.song, index: 0, initialIndex: widget.initialIndex, userData: userData),
                UserInfoWidget(
                  userData: userData,
                  getInfoText: (userData) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        song.description,
                        style: TextStyle(fontSize: 15, height: 1.3, letterSpacing: -0.3), maxLines: 4, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,
                      ),
                    );
                  },
                  onShowMorePressed: (context, userData) {
                    showMoreDescriptionBottomDialog(context, userData, song.description);
                  },
                ),
                _buildProfileInfo(context, userData),
              ],
            );
          },
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

  Widget _buildProfileInfo(BuildContext context, Map<String, dynamic> userData) {
    final userImage = userData['image'] as String?;
    final user = FirebaseAuth.instance.currentUser;
    final isCurrentUser = widget.song.uploadedBy == user?.uid;

    return InkWell(
      onTap: () {
        Navigator.push(context, createPageRoute(ProfileSettingsScreen(initialIndex: widget.initialIndex)));
      },
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(border: Border.all(color: AppColors.darkGrey), borderRadius: BorderRadius.circular(AppSizes.cardRadiusXl)),
              child: CircleAvatar(
                radius: 25,
                backgroundImage: userImage != null ? NetworkImage(userImage) : null,
                backgroundColor: AppColors.grey,
              ),
            ),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(widget.song.uploadedBy, style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeSm)),
                    SizedBox(width: 7),
                    Icon(FluentIcons.checkmark_starburst_24_filled, color: AppColors.blue, size: 16),
                  ],
                ),
                const SizedBox(height: 2),
                Text(userData['city'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.grey)),
              ],
            ),
            const Spacer(),
            if (isCurrentUser)
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: context.isDarkMode ? AppColors.darkGrey : AppColors.lightGrey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                side: BorderSide.none,
              ),
              child: Text('Following', style: TextStyle(color: context.isDarkMode ? AppColors.white : AppColors.black, fontSize: AppSizes.fontSizeMd)),
            ),
          ],
        ),
      ),
    );
  }
}
