import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestro/features/upgrade/screens/see_all_plans_screen.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_images.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../upgrade/widgets/dialogs/restrictions_apply_dialog.dart';

class SpotlightScreen extends StatelessWidget {

  const SpotlightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child: SizedBox(
                    width: 220,
                    height: 270,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 180,
                          height: 230,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage(AppImages.artistBg), fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        Positioned(
                          left: 5,
                          bottom: 5,
                          child: Container(
                            width: 180,
                            height: 230,
                            decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage(AppImages.artist), fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 35,
                right: 15,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: AppColors.darkGrey, shape: BoxShape.circle),
                    child: Icon(Icons.close, color: AppColors.white, size: 24),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 4, right: 8, top: 2, bottom: 2),
                  decoration: BoxDecoration(
                    color: AppColors.darkGrey,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
                        child: Icon(Icons.star, color: AppColors.white, size: 12),
                      ),
                      SizedBox(width: 4),
                      Text('ARTIST PRO', style: TextStyle(fontSize: AppSizes.fontSizeLm, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.info,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text('FOR ARTISTS', style: TextStyle(fontSize: AppSizes.fontSizeLm, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Spotlight your best tracks & more.', style: TextStyle(fontSize: AppSizes.fontSizeXxl, fontWeight: FontWeight.bold, height: 1, letterSpacing: -1.5)),
          ),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('For 1 750,00 ₽, billed monthly.', style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w400, fontFamily: 'Roboto'), textAlign: TextAlign.left),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.w400),
                children: [
                  TextSpan(
                    text: 'Cancel anytime. ',
                  ),
                  TextSpan(
                    text: 'Restriction apply',
                    style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.w400, decoration: TextDecoration.none),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      showRestrictionApplyDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: context.isDarkMode ? AppColors.white : AppColors.black,
                    foregroundColor: context.isDarkMode ? AppColors.buttonDarkGrey : AppColors.lightGrey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    side: BorderSide.none,
                  ),
                  child: Text('Get Artist Pro', style: TextStyle(color: context.isDarkMode ? AppColors.black : AppColors.white)),
                ),
                SizedBox(height: 6),
                InkWell(
                  onTap: () {
                    Navigator.push(context, createPageRoute(SeeAllPlansScreen(indexCard: 1)));
                  },
                  splashColor: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
                  highlightColor: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.transparent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'See all plans',
                      style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w400, color: AppColors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
