import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maestro/common/widgets/app_bar/app_bar.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import 'package:maestro/utils/constants/app_vectors.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../home/screens/home_screen.dart';
import '../../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../bloc/language_cubit.dart';

class SelectLanguageScreen extends StatefulWidget {
  final int initialIndex;

  const SelectLanguageScreen({super.key, required this.initialIndex});

  @override
  State<SelectLanguageScreen> createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  late final int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {

  final List<Map<String, String>> languages = [
    {'code': 'ru', 'image': AppVectors.rus, 'title': S.of(context).russianLanguage},
    {'code': 'en', 'image': AppVectors.usa, 'title': S.of(context).englishLanguage},
    {'code': 'es', 'image': AppVectors.esp, 'title': S.of(context).spanishLanguage},
    {'code': 'de', 'image': AppVectors.deu, 'title': S.of(context).deutschLanguage},
    {'code': 'fr', 'image': AppVectors.fra, 'title': S.of(context).frenchLanguage},
    {'code': 'it', 'image': AppVectors.ita, 'title': S.of(context).italianLanguage},
    {'code': 'pt', 'image': AppVectors.prt, 'title': S.of(context).portugueseLanguage},
  ];

    return Scaffold(
      appBar: BasicAppBar(
        title: const Text('Select language', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: BlocBuilder<LanguageCubit, Locale>(
        builder: (context, locale) {
          return ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: ListView(
              children: [
                const SizedBox(height: 8),
                ...languages.map((lang) => _buildLanguageTile(
                  context,
                  languageCode: lang['code']!,
                  image: lang['image']!,
                  title: lang['title']!,
                  selected: locale.languageCode == lang['code'],
                )),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: (index) {
          Navigator.pushReplacement(context, createPageRoute(HomeScreen(initialIndex: index)));
        },
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context, {
    required String languageCode,
    required String image,
    required String title,
    required bool selected,
  }) {
    return InkWell(
      onTap: () {
        context.read<LanguageCubit>().setLanguage(languageCode);
        Navigator.pop(context);
      },
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 8, top: 6, bottom: 6),
        child: Row(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(3), child: SvgPicture.asset(image, width: 23, height: 23, fit: BoxFit.cover)),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.normal))),
            Radio<String>(
              value: languageCode,
              groupValue: selected ? languageCode : null,
              onChanged: (value) {
                if (value != null) {
                  context.read<LanguageCubit>().setLanguage(value);
                  Navigator.pop(context);
                }
              },
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
