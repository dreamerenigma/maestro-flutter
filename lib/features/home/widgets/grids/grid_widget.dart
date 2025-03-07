import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';

class GridWidget extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final String sectionTitle;
  final String subtitleText;
  final int itemCount;
  final double height;
  final double width;
  final double heights;
  final VoidCallback? onItemTap;

  const GridWidget({
    super.key,
    required this.padding,
    required this.sectionTitle,
    required this.subtitleText,
    this.itemCount = 2,
    this.height = 130,
    this.width = 130,
    this.heights = 150,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> cardTexts = List.generate(15, (index) => 'Item ${index + 1}');
    final double itemWidth = width == double.infinity ? MediaQuery.of(context).size.width / itemCount : width;

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: Text(sectionTitle, style: TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.w800)),
          ),
          SizedBox(
            height: heights,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: itemCount,
              itemBuilder: (context, index) {
                bool isLastItem = index == itemCount - 1;

                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 10 : 0,
                    right: (isLastItem && (itemCount == 10 || itemCount == 5 || itemCount == 15)) ? 10 : 0,
                  ),
                  child: InkWell(
                    onTap: onItemTap,
                    splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                    highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                    borderRadius: BorderRadius.circular(AppSizes.cardRadiusLg),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: itemWidth,
                            height: height,
                            decoration: BoxDecoration(
                              color: AppColors.darkGrey,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.darkerGrey.withAlpha((0.5 * 255).toInt()), width: 1),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                AppVectors.defaultAlbum,
                                width: 60,
                                height: 60,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            cardTexts[index],
                            style: const TextStyle(fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            subtitleText,
                            style: const TextStyle(color: AppColors.grey, fontSize: 13, height: 1),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
