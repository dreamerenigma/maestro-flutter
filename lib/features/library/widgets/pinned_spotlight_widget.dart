import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../screens/spotlight_screen.dart';

class PinnedSpotlightWidget extends StatelessWidget {
  const PinnedSpotlightWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Pinned to Spotlight',
                  style: TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.bold, letterSpacing: -1.3),
                ),
              ),
              SizedBox(
                width: 50,
                height: 27,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, createPageRoute(const SpotlightScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.isDarkMode ? AppColors.darkGrey : AppColors.lightGrey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                    side: BorderSide.none,
                  ).copyWith(
                    foregroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.pressed)) {
                        return AppColors.darkerGrey;
                      } else {
                        return AppColors.white;
                      }
                    }),
                  ),
                  child: const Text('Edit', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                ),
              ),
            ],
          ),
          Text(
            'Pin items to your Spotlight',
            style: TextStyle(color: AppColors.lightGrey, fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.normal, letterSpacing: -0.8),
          ),
        ],
      ),
    );
  }
}
