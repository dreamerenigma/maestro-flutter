import 'package:flutter/material.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../tiles/background_tile.dart';

class GenreGrid extends StatelessWidget {
  final int initialIndex;
  final String sectionTitle;

  GenreGrid({super.key, required this.sectionTitle, required this.initialIndex});

  List<Widget> _buildCardTiles() {
    return [
      BackGroundTile(backgroundColor: AppColors.deepPurpleCard, icondata: Icons.home, borderColor: AppColors.deepPurpleCard, index: 0, text: 'Hip Hop & Rap', initialIndex: initialIndex),
      BackGroundTile(backgroundColor: AppColors.pinkCard, icondata: Icons.ac_unit, borderColor: AppColors.pinkCard, index: 1, text: 'Electronic', initialIndex: initialIndex),
      BackGroundTile(backgroundColor: AppColors.amberCard, icondata: Icons.landscape, borderColor: AppColors.amberCard, index: 2, text: 'Pop', initialIndex: initialIndex),
      BackGroundTile(backgroundColor: AppColors.blueGreenCard, icondata: Icons.portrait, borderColor: AppColors.blueGreenCard, index: 3, text: 'R&B', initialIndex: initialIndex),
      BackGroundTile(backgroundColor: AppColors.richOrangeCard, icondata: Icons.access_alarms, borderColor: AppColors.richOrangeCard, index: 4, text: 'Party', initialIndex: initialIndex),
      BackGroundTile(backgroundColor: AppColors.blueGreenCard, icondata: Icons.music_note, borderColor: AppColors.blueGreenCard, index: 5, text: 'Chill', initialIndex: initialIndex),
      BackGroundTile(backgroundColor: AppColors.greenCard, icondata: Icons.satellite_outlined, borderColor: AppColors.greenCard, index: 6, text: 'Workout', initialIndex: initialIndex),
      BackGroundTile(backgroundColor: AppColors.pinkCard, icondata: Icons.music_note, borderColor: AppColors.pinkCard, index: 7, text: 'Techno', initialIndex: initialIndex),
      BackGroundTile(backgroundColor: AppColors.pinkCard, icondata: Icons.music_note, borderColor: AppColors.pinkCard, index: 8, text: 'House', initialIndex: initialIndex),
      BackGroundTile(backgroundColor: AppColors.amberCard, icondata: Icons.music_note, borderColor: AppColors.amberCard, index: 9, text: 'Feel Good', initialIndex: initialIndex),
      BackGroundTile(backgroundColor: AppColors.blueCard, icondata: Icons.flight_takeoff, borderColor: AppColors.blueCard, index: 10, text: 'Healing Era', initialIndex: initialIndex),
      BackGroundTile(backgroundColor: AppColors.deepPurpleCard, icondata: Icons.directions_car, borderColor: AppColors.deepPurpleCard, index: 11, text: 'At home', initialIndex: initialIndex),
      BackGroundTile(backgroundColor: AppColors.pinkCard, icondata: Icons.home_work, borderColor: AppColors.pinkCard, index: 12, text: 'Study', initialIndex: initialIndex),
      BackGroundTile(backgroundColor: AppColors.richOrangeCard, icondata: Icons.business, borderColor: AppColors.richOrangeCard, index: 13, text: 'Folk', initialIndex: initialIndex),
      BackGroundTile(backgroundColor: AppColors.blueCard, icondata: Icons.coffee, borderColor: AppColors.blueCard, index: 14, text: 'Indie', initialIndex: initialIndex),
      BackGroundTile(backgroundColor: AppColors.blueGreenCard, icondata: Icons.dashboard, borderColor: AppColors.blueGreenCard, index: 15, text: 'Soul', initialIndex: initialIndex),
      BackGroundTile(backgroundColor: AppColors.richOrangeCard, icondata: Icons.email, borderColor: AppColors.richOrangeCard, index: 16, text: 'Country', initialIndex: initialIndex),
      BackGroundTile(backgroundColor: AppColors.pinkCard, icondata: Icons.favorite, borderColor: AppColors.pinkCard, index: 17, text: 'Latin', initialIndex: initialIndex),
      BackGroundTile(backgroundColor: AppColors.redCard, icondata: Icons.visibility, borderColor: AppColors.redCard, index: 18, text: 'Rock', initialIndex: initialIndex),
    ];
  }

  final List<double> _tileHeights = [
    170.0, 240.0, 240.0, 85.0, 170.0, 85.0, 170.0, 240.0, 240.0, 85.0,
    170.0, 85.0, 170.0, 240.0, 240.0, 170.0, 85.0, 170.0, 85.0,
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> tiles = _buildCardTiles();

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.only(left: 4, top: 25, bottom: 8),
                      child: Text(sectionTitle, style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold, letterSpacing: -1.3)),
                    ),
                  ],
                ),
              ),
              SliverWaterfallFlow(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final tileHeight = _tileHeights[index];
                    return SizedBox(height: tileHeight, child: tiles[index]);
                  },
                  childCount: tiles.length,
                ),
                gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
