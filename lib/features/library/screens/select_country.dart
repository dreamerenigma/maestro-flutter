import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:maestro/common/widgets/app_bar/app_bar.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import '../../../data/models/country/country_model.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../controllers/country_controller.dart';
import '../widgets/lists/country_list.dart';

class SelectCountryScreen extends StatefulWidget {
  const SelectCountryScreen({super.key});

  @override
  State<SelectCountryScreen> createState() => _SelectCountryScreenState();
}

class _SelectCountryScreenState extends State<SelectCountryScreen> {
  bool _isSearching = false;
  final countryController = Get.put(CountryController());
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<CountryModel> _filteredCountries = [];

  @override
  void initState() {
    super.initState();
    _filteredCountries = List.from(countries);

    final selectedCountry = countryController.selectedCountry.value;
    if (_filteredCountries.contains(selectedCountry)) {
      _filteredCountries.remove(selectedCountry);
      _filteredCountries.insert(0, selectedCountry!);
    }

    _searchController.addListener(_filterCountries);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (_isSearching) {
        _searchFocusNode.requestFocus();
      } else {
        _searchController.clear();
        _searchFocusNode.unfocus();
      }
    });
  }

  void _filterCountries() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      final filtered = countries.where((country) {
        final countryName = country.name.toLowerCase();
        final countryNativeName = country.nativeName.toLowerCase();
        final countryCode = country.code.toLowerCase();

        return countryName.contains(query) ||
            countryNativeName.contains(query) ||
            countryCode.contains(query);
      }).toList();

      final selectedCountry = countryController.selectedCountry.value;

      if (filtered.contains(selectedCountry)) {
        filtered.remove(selectedCountry);
        filtered.insert(0, selectedCountry!);
      }

      _filteredCountries = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSearching ? null : PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BasicAppBar(
          title: const Text('Select country', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: _toggleSearch,
              icon: const Icon(EvaIcons.search, color: AppColors.lightGrey, size: 26),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          if (_isSearching)
          Padding(
            padding: EdgeInsets.only(
              left: 12,
              right: 12,
              top: MediaQuery.of(context).padding.top + 5,
              bottom: 4,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextSelectionTheme(
                    data: TextSelectionThemeData(
                      cursorColor: AppColors.primary,
                      selectionColor: AppColors.primary.withAlpha((0.3 * 255).toInt()),
                      selectionHandleColor: AppColors.primary,
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).brightness == Brightness.dark ? AppColors.popupColorDark.withAlpha((0.5 * 255).toInt()) : AppColors.grey.withAlpha((0.2 * 255).toInt()),
                        hintText: 'Поиск стран',
                        hintStyle: TextStyle(color: AppColors.darkerGrey, fontSize: AppSizes.fontSizeMd),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                        prefixIcon: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Theme.of(context).brightness == Brightness.dark ? AppColors.white : AppColors.black,
                          ),
                          onPressed: _toggleSearch,
                        ),
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: ListView.separated(
                itemCount: _filteredCountries.length,
                separatorBuilder: (context, index) => Divider(
                  height: 0,
                  thickness: 1,
                  color: Theme.of(context).brightness == Brightness.dark ? AppColors.youngNight : AppColors.grey,
                ),
                itemBuilder: (context, index) {
                  final country = _filteredCountries[index];
                  final isSelected = country == countryController.selectedCountry.value;

                  return InkWell(
                    onTap: () {
                      countryController.selectedCountry.value = country;
                      Navigator.pop(context, {
                        'name': country.name,
                        'nativeName': country.nativeName,
                        'flag': country.flag,
                        'code': country.code,
                      });
                    },
                    splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                    highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: SizedBox(
                              width: 25,
                              height: 20,
                              child: SvgPicture.asset(country.flag),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 220,
                                child: Text(
                                  country.name,
                                  style: TextStyle(
                                    fontSize: AppSizes.fontSizeMd,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? AppColors.primary : (context.isDarkMode ? AppColors.white : AppColors.black),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (country.nativeName.isNotEmpty)
                              Text(
                                country.nativeName,
                                style: TextStyle(fontSize: AppSizes.fontSizeSm, color: AppColors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: isSelected ? 10 : 28),
                                child: Text(country.code, style: const TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.normal)),
                              ),
                              if (isSelected)
                                Icon(Icons.check, color: AppColors.primary, size: AppSizes.iconMd),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
