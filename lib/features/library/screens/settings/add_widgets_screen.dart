import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../common/widgets/app_bar/app_bar.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../home/screens/home_screen.dart';
import '../../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../../song_player/widgets/mini_player/mini_player_manager.dart';

class AddWidgetsScreen extends StatefulWidget {
  final int initialIndex;

  const AddWidgetsScreen({super.key, required this.initialIndex});

  @override
  State<AddWidgetsScreen> createState() => _AddWidgetsScreenState();
}

class _AddWidgetsScreenState extends State<AddWidgetsScreen> {
  late final int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: const Text('Add widgets', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
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
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Select a widget to add to home screen',
                  style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.normal),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            _buildLickedTracks(),
            SizedBox(height: 12),
            _buildPlayer(),
          ],
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

  Widget _buildLickedTracks() {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: () {},
        splashColor: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
        highlightColor: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16),
          color: AppColors.darkGrey,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16),
                color: AppColors.darkGrey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Transform.rotate(angle: 45 * 3.14159 / 180, child: Icon(BootstrapIcons.pin, size: 24)),
                    SizedBox(width: 16),
                    Text('Liked tracks', style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 26,
                            height: 26,
                            child: SvgPicture.asset(AppVectors.avatar, width: 26, height: 26),
                          ),
                          SizedBox(width: 8),
                          Text('Liked tracks', style: TextStyle(color: AppColors.lightGrey, fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.normal)),
                          Spacer(),
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: SvgPicture.asset(
                              AppVectors.defaultAlbum,
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.darkGrey,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.darkerGrey.withAlpha((0.2 * 255).toInt()), width: 1),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                AppVectors.defaultAlbum,
                                width: 45,
                                height: 45,
                                colorFilter: ColorFilter.mode(AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()), BlendMode.srcIn),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayer() {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: () {},
        splashColor: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
        highlightColor: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 25, bottom: 18),
          color: AppColors.darkGrey,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16),
                color: AppColors.darkGrey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Transform.rotate(angle: 45 * 3.14159 / 180, child: Icon(BootstrapIcons.pin, size: 24)),
                    SizedBox(width: 16),
                    Text('Player', style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 8),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.youngNight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 75,
                            height: 75,
                            decoration: BoxDecoration(
                              color: AppColors.darkGrey,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.darkerGrey.withAlpha((0.2 * 255).toInt()), width: 1),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                AppVectors.defaultAlbum,
                                width: 45,
                                height: 45,
                                colorFilter: ColorFilter.mode(AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()), BlendMode.srcIn),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Track Tile · Artist Name', style: TextStyle(fontSize: AppSizes.fontSizeSm, color: AppColors.white, fontWeight: FontWeight.w100)),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      spacing: 14,
                                      runSpacing: 14,
                                      children: List.generate(3, (index) {
                                        final List<IconData> icons = [
                                          Icons.skip_previous,
                                          Icons.play_arrow,
                                          Icons.skip_next,
                                        ];

                                        return Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: AppColors.black,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: AppColors.white, width: 1),
                                          ),
                                          child: Center(
                                            child: Icon(icons[index], size: 38, color: AppColors.white),
                                          ),
                                        );
                                      }),
                                    ),
                                    SizedBox(width: 16),
                                    Icon(CarbonIcons.favorite, size: 36, color: AppColors.white),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
