import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../../data/sources/search/search_service.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../generated/l10n/l10n.dart';
import '../../utils/dialogs/cast_to_dialog.dart';
import '../../utils/screens/internet_aware_screen.dart';
import '../widgets/grids/gener_grid.dart';

class SearchScreen extends StatefulWidget {
  final int initialIndex;

  const SearchScreen({super.key, required this.initialIndex});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _isLoading = true;
  bool _noResultsFound = false;
  final FocusNode _focusNode = FocusNode();
  bool _hasFocus = false;
  bool _hasText = false;
  final TextEditingController _searchController = TextEditingController();
  final SearchService _searchService = SearchService();

  List<QueryDocumentSnapshot> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _loadData();

    _focusNode.addListener(() {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    });

    _searchController.addListener(() async {
      setState(() {
        _hasText = _searchController.text.isNotEmpty;
        if (_hasText) {
          _noResultsFound = false;
        }
      });

      if (_hasText) {
        var users = await _searchService.searchUsers(_searchController.text);
        var songs = await _searchService.searchSongs(_searchController.text);

        setState(() {
          _searchResults = [...users, ...songs];
          if (_searchResults.isEmpty) {
            _noResultsFound = true;
          } else {
            _noResultsFound = false;
          }
          _isLoading = false;
        });
      } else {
        setState(() {
          _searchResults = [];
          _isLoading = false;
          _noResultsFound = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isLoading = false;
        if (_hasText && _noResultsFound) {
          _noResultsFound = true;
        }
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _hasText = false;
      _noResultsFound = false;
    });
  }

  void _removeFocus() {
    _focusNode.unfocus();
    setState(() {
      _hasFocus = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 16, right: 4, top: 40),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: TextSelectionTheme(
                              data: TextSelectionThemeData(
                                cursorColor: AppColors.primary,
                                selectionColor: AppColors.primary.withAlpha((0.3 * 255).toInt()),
                                selectionHandleColor: AppColors.primary,
                              ),
                              child: TextField(
                                textInputAction: _hasText ? TextInputAction.done : TextInputAction.search,
                                controller: _searchController,
                                focusNode: _focusNode,
                                textCapitalization: TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  hintText: S.of(context).search,
                                  hintStyle: TextStyle(color: context.isDarkMode ? AppColors.darkerGrey : AppColors.darkerGrey, fontSize: AppSizes.fontSizeLg),
                                  prefixIcon: IconButton(
                                    icon: Icon(_hasFocus ? Icons.arrow_back : EvaIcons.search),
                                    color: context.isDarkMode ? AppColors.white : AppColors.darkGrey,
                                    onPressed: _hasFocus ? _removeFocus : () {},
                                  ),
                                  suffixIcon: _hasText ? IconButton(icon: const Icon(IonIcons.close_circle, color: AppColors.white), onPressed: _clearSearch) : null,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                                  filled: true,
                                  fillColor: context.isDarkMode ? AppColors.darkGrey : AppColors.lightGrey,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                                ),
                                style: TextStyle(fontSize: AppSizes.fontSizeLg, fontWeight: FontWeight.w400),
                                onChanged: (text) {
                                  setState(() {
                                    _hasText = text.isNotEmpty;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        IconButton(
                          icon: const Icon(Icons.cast, size: 23),
                          onPressed: () {
                            showCastToDialog(context);
                          },
                        ),
                      ],
                    ),
                    if (!_hasFocus && _searchResults.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {},
                        child: Text('Recent searches', style: TextStyle(fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    if (_hasFocus || (_noResultsFound && !_isLoading && !_hasText)) ...[
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Search Maestro',
                              style: TextStyle(fontSize: AppSizes.fontSizeLg, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Find artists, tracks, albums, and playlists.',
                              style: TextStyle(fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (_isLoading) const SizedBox(height: 20),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary))),
                    if (_noResultsFound && !_isLoading && _hasText)
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('No suggestions for current search', style: TextStyle(fontSize: AppSizes.fontSizeLg, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Text('Check the spelling or try a different search', style: TextStyle(fontSize: AppSizes.fontSizeSm)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              if (!_isLoading && !_hasFocus && !_noResultsFound) GenreGrid(sectionTitle: "Vibes", initialIndex: widget.initialIndex),
              SizedBox(height: 60),
            ],
          ),
          Positioned(
            top: kToolbarHeight + 30,
            left: 0,
            right: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: InternetAwareScreen(title: 'Search Screen', connectedScreen: Container()),
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
