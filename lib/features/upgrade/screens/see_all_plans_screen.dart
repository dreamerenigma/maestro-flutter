import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import 'package:maestro/utils/constants/app_images.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../widgets/dialogs/restrictions_apply_dialog.dart';

class SeeAllPlansScreen extends StatefulWidget {
  final int initialIndex;
  final int indexCard;

  const SeeAllPlansScreen({super.key, this.initialIndex = 4, this.indexCard = 0});

  @override
  State<SeeAllPlansScreen> createState() => SeeAllPlansScreenState();
}

class SeeAllPlansScreenState extends State<SeeAllPlansScreen> {
  final List<bool> _isRotated = [false, false];
  final List<Color> _bgColors = [AppColors.transparent, AppColors.transparent];
  final List<bool> _isExpanded = [false, false];
  int _currentPage = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.indexCard;

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lightBgColor = theme.brightness == Brightness.light ? AppColors.lightGrey : Colors.grey[800] ?? AppColors.grey;
    final highlightColor = theme.brightness == Brightness.light ? AppColors.grey : Colors.grey[600] ?? AppColors.grey;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  AppImages.upgradeBg,
                ),
              ),
            ),
          ),
          Container(color: AppColors.black.withAlpha((0.15 * 255).toInt())),
          ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 90),
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'What\'s next in music is first on Maestro',
                            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.white, fontSize: 30, height: 1.2, letterSpacing: -0.5),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Whether you want to share your sound or enjoy ad-free listening, we have the right plan for you.',
                            style: TextStyle(fontWeight: FontWeight.w200, color: AppColors.lightGrey, fontSize: 15, height: 1.5, letterSpacing: -0.5),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      _isLoading ? SizedBox(height: 475, child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.white))))
                        : _buildCarousel(context),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildSupport(),
                  _buildComment(),
                  _buildQuestions(lightBgColor, highlightColor, theme),
                ],
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
    );
  }

  Widget _buildCarousel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 10),
      child: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 395,
              viewportFraction: 0.84,
              initialPage: _currentPage,
              enableInfiniteScroll: false,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentPage = index;
                });
              },
            ),
            items: [
              _buildProCard('FOR ARTISTS', 'Artist Pro', '10 850,00 \u20BD/year', context),
              _buildProCard('FOR ARTISTS', 'Artist Pro', '1 750,00 \u20BD/month', context),
            ],
          ),
          const SizedBox(height: 20),
          SmoothPageIndicator(
            controller: PageController(initialPage: _currentPage),
            count: 2,
            effect: SlideEffect(
              dotWidth: 10,
              dotHeight: 10,
              activeDotColor: AppColors.black,
              dotColor: AppColors.darkGrey,
              spacing: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProCard(String label, String title, String price, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: context.isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: const BoxDecoration(
                color: AppColors.info,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Text(
                label,
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.white, fontSize: AppSizes.fontSizeLm),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, color: context.isDarkMode ? AppColors.white : AppColors.black, fontSize: AppSizes.fontSizeXl, height: 1.2),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Container(
                    decoration: BoxDecoration(color: AppColors.orange, shape: BoxShape.circle),
                    padding: const EdgeInsets.all(1),
                    child: Icon(Icons.star_rate_rounded, color: AppColors.white, size: 12),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              price,
              style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w600, color: context.isDarkMode ? AppColors.white : AppColors.black, fontSize: AppSizes.fontSizeLg, height: 1.2),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildUpgradeOption('Unlock unlimited upload time', Icons.check, () {}),
                  _buildUpgradeOption('Get paid fairly for your plays', Icons.check, () {}),
                  _buildUpgradeOption('Access advanced audience insights', Icons.check, () {}),
                  _buildUpgradeOption('Replace your track without losing its stats', Icons.check, () {}),
                  _buildUpgradeOption('Pin your favourite tracks', Icons.check, () {}),
                  _buildMessagePurchased(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpgradeOption(String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.green),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontWeight: FontWeight.w200, color: context.isDarkMode ? AppColors.white : AppColors.black, fontSize: AppSizes.fontSizeSm, letterSpacing: -0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagePurchased() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                side: BorderSide.none,
              ),
              child: Text(
                'Subscribe now',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.black, fontSize: AppSizes.fontSizeMd),
              ),
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              text: 'Cancel anytime. ',
              style: TextStyle(fontWeight: FontWeight.normal, color: context.isDarkMode ? AppColors.white : AppColors.black, fontSize: AppSizes.fontSizeSm),
              children: [
                TextSpan(
                  text: 'Restrictions apply',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: AppColors.blue,
                    fontSize: AppSizes.fontSizeSm,
                    decoration: TextDecoration.none,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {
                    showRestrictionApplyDialog(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupport() {
    return Container(
      width: double.infinity,
      height: 230,
      decoration: BoxDecoration(color: context.isDarkMode ? AppColors.black : AppColors.lightGrey),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          Text(
            'Maestro support independent artists',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: context.isDarkMode ? AppColors.white : AppColors.black,
              fontSize: 30,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'From fan-powered royalties to our audience-building artist plans, your subscription helps support the Maestro global community.',
            style: TextStyle(
              fontFamily: 'Roboto',
              color: context.isDarkMode ? AppColors.lightGrey : AppColors.black,
              fontSize: AppSizes.fontSizeMd,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComment() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 25),
      child: Row(
        children: [
          ClipRect(
            clipBehavior: Clip.none,
            child: SizedBox(
              width: 150,
              height: 200,
              child: Stack(
                children: [
                  Positioned(
                    top: 50,
                    child: Image.asset(
                      AppImages.comment,
                      width: 150,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 25),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '"It\'s such a simple idea. Your monthly fees get split between the songs you actually listen to."',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.white, fontSize: AppSizes.fontSizeMd, height: 1.2, letterSpacing: -0.5),
                ),
                const SizedBox(height: 25),
                const Text(
                  '— RAC, musician and producer',
                  style: TextStyle(fontWeight: FontWeight.normal, color: AppColors.white, fontSize: AppSizes.fontSizeSm),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestions(Color lightBgColor, Color highlightColor, ThemeData theme) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: context.isDarkMode ? AppColors.black : AppColors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Frequently asked questions',
              style: TextStyle(fontWeight: FontWeight.bold, color: context.isDarkMode ? AppColors.white : AppColors.black, fontSize: AppSizes.fontSizeGl),
            ),
          ),
          const SizedBox(height: 10),
          _buildQuestionRow(
            'What\'s the difference between fan and artist plans?',
            Icons.keyboard_arrow_down_rounded,
            0,
            lightBgColor,
            highlightColor,
            theme,
            'Our Fan-oriented plans are designed for those who primarily visit site to listen to Maestro\'s 250+ million tracks. Artist plans offer unique features designed to help artists create and distribute their music and content.'
          ),
          const SizedBox(height: 30),
          _buildQuestionRow(
            'Can I purchase an annual plan and/or family plan?',
            Icons.keyboard_arrow_down_rounded,
            1,
            lightBgColor,
            highlightColor,
            theme,
            'Unfortunately we do not currently offer an annual or family plan option for purchase in the app.'
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildQuestionRow(String text, IconData icon, int index, Color lightBgColor, Color highlightColor, ThemeData theme, String answer) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _isRotated[index] = !_isRotated[index];
            _isExpanded[index] = !_isExpanded[index];
          });
        },
        onTapDown: (details) {
          setState(() {
            _bgColors[index] = highlightColor;
          });
        },
        onTapCancel: () {
          setState(() {
            _bgColors[index] = AppColors.transparent;
          });
        },
        onTapUp: (details) {
          setState(() {
            _bgColors[index] = AppColors.transparent;
          });
        },
        splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
        highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          color: _bgColors[index],
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      text,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeMd, height: 1.3, letterSpacing: -0.7),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isRotated[index] ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(icon, size: 30, color: theme.iconTheme.color ?? AppColors.black),
                  ),
                ],
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: _isExpanded[index]
                  ? Padding(
                    padding: const EdgeInsets.only(right: 23, top: 10.0),
                    child: Text(
                      answer,
                      style: TextStyle(fontSize: AppSizes.fontSizeSm, color: context.isDarkMode ? AppColors.lightGrey : AppColors.black),
                    ),
                  )
                  : SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
