import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';

class SearchResults extends StatelessWidget {
  final bool isLoading;
  final bool noResultsFound;
  final bool hasText;
  final List<QueryDocumentSnapshot> searchResults;
  final void Function(QueryDocumentSnapshot) onResultTap;

  const SearchResults({
    super.key,
    required this.isLoading,
    required this.noResultsFound,
    required this.hasText,
    required this.searchResults,
    required this.onResultTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)));
    }

    if (noResultsFound && hasText) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('No suggestions for current search', style: TextStyle(fontSize: AppSizes.fontSizeLg, fontWeight: FontWeight.bold)),
              const SizedBox(height: 3),
              Text('Check the spelling or try a different search', style: TextStyle(fontSize: AppSizes.fontSizeSm)),
            ],
          ),
        ),
      );
    }

    log('Rendering ${searchResults.length} search results');

    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 6),
        shrinkWrap: true,
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          var result = searchResults[index];
          var data = result.data() as Map<String, dynamic>;

          String title = data['name'] ?? data['title'] ?? 'No title';
          String image = data['image'] ?? data['cover'] ?? '';

          return InkWell(
            onTap: () => onResultTap(result),
            splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
            highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 12, top: 10, bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()), width: 1)),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.lightGrey,
                      backgroundImage: image.isNotEmpty ? NetworkImage(image) : null,
                      child: image.isEmpty ? SvgPicture.asset(AppVectors.avatar, width: 50, height: 50) : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title.toLowerCase().split('.').first, style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w200)),
                      ],
                    ),
                  ),
                  Transform.rotate(angle: 320 * 3.14159265359 / 180, child: Icon(HeroIcons.arrow_small_up, size: 28)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
