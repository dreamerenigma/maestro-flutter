import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maestro/common/widgets/app_bar/app_bar.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../bloc/language_cubit.dart';

class SelectLanguageScreen extends StatefulWidget {
  const SelectLanguageScreen({super.key});

  @override
  State<SelectLanguageScreen> createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {

  final List<Map<String, String>> languages = [
    {'code': 'ru', 'image': AppImages.russiaFlag, 'title': 'Русский'},
    {'code': 'en', 'image': AppImages.usaFlag, 'title': 'English'},
    {'code': 'es', 'image': AppImages.spainFlag, 'title': 'Español'},
  ];

  @override
  Widget build(BuildContext context) {
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
            Image.asset(image, width: 25, height: 25),
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
              activeColor: AppColors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
