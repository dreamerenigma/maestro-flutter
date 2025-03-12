import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

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
          String description = data.containsKey('description') ? data['description'] : '';
          String image = data['image'] ?? '';

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
                    decoration: BoxDecoration(
                      color: AppColors.darkerGrey.withAlpha((0.5 * 255).toInt()),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: AppColors.darkGrey, width: 1),
                    ),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundImage: image.isNotEmpty ? NetworkImage(image) : null,
                      child: image.isEmpty ? Icon(Icons.person, size: 28, color: AppColors.grey) : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title.toLowerCase(), style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w200)),
                        if (description.isNotEmpty)
                          Text(description.toLowerCase(), style: TextStyle(fontSize: AppSizes.fontSizeMd, color: AppColors.grey)),
                      ],
                    ),
                  ),
                  Transform.rotate(
                    angle: 320 * 3.14159265359 / 180,
                    child: Icon(HeroIcons.arrow_small_up, size: 28),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
