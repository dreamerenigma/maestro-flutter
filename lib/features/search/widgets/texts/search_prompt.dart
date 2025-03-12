import 'package:flutter/material.dart';
import '../../../../utils/constants/app_sizes.dart';

class SearchPrompt extends StatelessWidget {
  const SearchPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Search Maestro', style: TextStyle(fontSize: AppSizes.fontSizeLg, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 5),
            Text('Find artists, tracks, albums, and playlists.', style: TextStyle(fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
