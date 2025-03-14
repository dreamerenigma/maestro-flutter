import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:ionicons/ionicons.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../api/apis.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../domain/entities/song/song_entity.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../library/widgets/switches.dart';
import '../widgets/lists/next_up_list.dart';

class NextUpScreen extends StatefulWidget {
  const NextUpScreen({super.key});

  @override
  State<NextUpScreen> createState() => _NextUpScreenState();
}

class _NextUpScreenState extends State<NextUpScreen> {
  late Future<Map<String, dynamic>?> userDataFuture;
  List<SongEntity> myTracks = [];
  bool _showStationAutoplay = false;

  @override
  void initState() {
    super.initState();
    userDataFuture = APIs.fetchUserData();
  }

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_station_autoplay', _showStationAutoplay);
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> tracks = List.generate(10, (index) => {'track': 'Track ${index + 1}', 'artist': 'Artist Name'});

    return Scaffold(
      appBar: BasicAppBar(
        padding: const EdgeInsets.only(left: 6, right: 10),
        title: const Text('Next up', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
        centerTitle: false,
        showCloseIcon: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Ionicons.shuffle_outline, size: 26),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {},
            splashColor: AppColors.darkGrey.withAlpha((0.8 * 255).toInt()),
            highlightColor: AppColors.darkGrey.withAlpha((0.8 * 255).toInt()),
            borderRadius: BorderRadius.circular(AppSizes.cardRadiusXl),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(
                AppVectors.repeat,
                colorFilter: ColorFilter.mode(context.isDarkMode ? AppColors.white : AppColors.black, BlendMode.srcIn),
                width: 24,
                height: 24,
              ),
            ),
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          child: FutureBuilder<Map<String, dynamic>?>(
            future: userDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)));
              } else if (snapshot.hasError || !snapshot.hasData) {
                return Center(child: Text(S.of(context).errorLoadingProfile));
              } else {
                final userData = snapshot.data;
                final userName = userData?['name'] ?? S.of(context).guest;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16, top: 16, bottom: 8),
                      child: Text("From profile $userName", style: TextStyle(fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.bold)),
                    ),
                    NextUpList(tracks: myTracks, userData: {}, shouldShowLikesListRow: false),
                    _buildStationAutoplay(context),
                  ],
                );
              }
            }
          ),
        ),
      ),
    );
  }

  Widget _buildStationAutoplay(BuildContext context) {
  return InkWell(
    onTap: () {},
    splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
    highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
    child: Padding(
      padding: const EdgeInsets.only(top: 60, bottom: 40),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(BoxIcons.bx_station, size: 24, color: context.isDarkMode ? AppColors.grey : AppColors.black),
                const SizedBox(width: 12),
                Text(
                  'Station Autoplay',
                  style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.bold, color: context.isDarkMode ? AppColors.grey : AppColors.black),
                ),
                const SizedBox(width: 12),
                CustomSwitch(
                  value: _showStationAutoplay,
                  onChanged: (bool value) {
                    setState(() {
                      _showStationAutoplay = value;
                    });
                    _saveSettings();
                  },
                  activeColor: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'New music based on what\'s playing',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: AppSizes.fontSizeSm, color: context.isDarkMode ? AppColors.grey : AppColors.darkGrey),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

}
