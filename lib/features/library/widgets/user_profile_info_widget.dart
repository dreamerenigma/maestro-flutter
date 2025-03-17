import 'package:flutter/material.dart';
import 'package:maestro/features/library/screens/library/following_screen.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../screens/library/followers_screen.dart';

class UserProfileInfo extends StatelessWidget {
  final int initialIndex;
  final String? userName;
  final String? city;
  final String? country;

  const UserProfileInfo({
    super.key,
    this.userName,
    this.city,
    this.country,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    bool hasCityAndCountry = (city != null && city!.isNotEmpty) && (country != null && country!.isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(userName ?? 'No Name', style: const TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.bold)),
        if (hasCityAndCountry)
        Text('$city, $country', style: const TextStyle(color: AppColors.buttonGrey, fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.normal)),
        const SizedBox(height: 4),
        Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context, createPageRoute(FollowersScreen(initialIndex: initialIndex)));
              },
              splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
              highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
              child: Text('346 Followers', style: const TextStyle(fontSize: 13, color: AppColors.buttonGrey, fontWeight: FontWeight.normal)),
            ),
            const Text(' · ', style: TextStyle(fontSize: AppSizes.fontSizeSm, color: AppColors.buttonGrey, fontWeight: FontWeight.normal)),
            InkWell(
              onTap: () {
                Navigator.push(context, createPageRoute(FollowingScreen(initialIndex: initialIndex)));
              },
              splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
              highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
              child: Text('18 Following', style: const TextStyle(fontSize: 13, color: AppColors.buttonGrey, fontWeight: FontWeight.normal)),
            ),
          ],
        ),
      ],
    );
  }
}
