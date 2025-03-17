import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/search/search_service.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_colors.dart';
import '../../utils/screens/internet_aware_screen.dart';
import '../widgets/bars/search_bar.dart' as search;
import '../widgets/bars/tab_bar_widget.dart';
import '../widgets/grids/genre_grid.dart';
import '../widgets/texts/search_results.dart';
import '../widgets/texts/search_prompt.dart';

class SearchScreen extends StatefulWidget {
  final int initialIndex;

  const SearchScreen({super.key, required this.initialIndex});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  bool _noResultsFound = false;
  late TabController _tabController;
  final FocusNode _focusNode = FocusNode();
  bool _hasFocus = false;
  bool _hasText = false;
  bool _isTabLoading = false;
  bool _isSearchResult = false;
  bool _showTabBarWidget = false;
  final TextEditingController _searchController = TextEditingController();
  final SearchService _searchService = SearchService();
  List<QueryDocumentSnapshot> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    _tabController = TabController(length: 5, vsync: this);

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
        var searchResults = await _searchService.searchByKeyword(_searchController.text);
        log('Search results: ${searchResults.length}');

        setState(() {
          _searchResults = searchResults;
          _noResultsFound = _searchResults.isEmpty;
          _isLoading = false;
          _showTabBarWidget = true;
        });
      } else {
        setState(() {
          _searchResults = [];
          _isLoading = false;
          _noResultsFound = false;
          _showTabBarWidget = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
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
      _isSearchResult = false;
      _showTabBarWidget = false;
    });
  }

  void _removeFocus() {
    _focusNode.unfocus();
    setState(() {
      _hasFocus = false;
    });
  }

  void _onResultTap(QueryDocumentSnapshot result) {
    log('Result tapped: ${result.data()}');

    setState(() {
      _isTabLoading = true;
      _isSearchResult = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isTabLoading = false;
      });

      log('Loading finished, state updated: _isTabLoading = $_isTabLoading');
    });
  }

  Future<void> _reloadData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _searchResults.isEmpty
        ? RefreshIndicator(
          onRefresh: _reloadData,
          displacement: 100,
          color: AppColors.primary,
          backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.softGrey,
          child: Stack(
            children: [
              Column(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: search.SearchBar(
                              searchController: _searchController,
                              searchFocusNode: _focusNode,
                              hasFocus: _hasFocus,
                              hasText: _hasText,
                              removeFocus: _removeFocus,
                              onChanged: (text) {
                                setState(() {
                                  _hasText = text.isNotEmpty;
                                });
                              },
                              clearSearch: _clearSearch,
                            ),
                          ),
                          SizedBox(width: 12),
                          Padding(
                            padding: const EdgeInsets.only(right: 4, top: 40, bottom: 8),
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.cast, size: 23, color: AppColors.lightGrey),
                            ),
                          ),
                        ],
                      ),
                      if (!_isTabLoading && _hasText && !_isLoading && !_isSearchResult)
                        SearchResults(
                          isLoading: _isLoading,
                          noResultsFound: _noResultsFound,
                          hasText: _hasText,
                          searchResults: _searchResults,
                          onResultTap: _onResultTap,
                        ),
                      if (_isTabLoading)
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: const Center(
                            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
                          ),
                        ),
                      if (!_isTabLoading && _isSearchResult && _showTabBarWidget)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TabBarWidget(initialIndex: 0),
                        ),
                      if (!_hasFocus && _searchResults.isNotEmpty)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {},
                            child: Text('Recent searches', style: TextStyle(fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      if (!_hasText && (_hasFocus || (_noResultsFound && !_isLoading && !_hasText)))
                        Center(child: const SearchPrompt()),
                      if (_isLoading)
                        const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary))),
                    ],
                  ),
                  if (!_isLoading && !_hasFocus && !_noResultsFound)
                    GenreGrid(sectionTitle: "Vibes", initialIndex: widget.initialIndex),
                ],
              ),
              Positioned(
                top: kToolbarHeight + 30,
                left: 0,
                right: 0,
                bottom: 0,
                child: Align(alignment: Alignment.topCenter, child: InternetAwareScreen(title: 'Search Screen', connectedScreen: Container())),
              ),
            ],
          ),
        )
      : Stack(
        children: [
          Column(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: search.SearchBar(
                          searchController: _searchController,
                          searchFocusNode: _focusNode,
                          hasFocus: _hasFocus,
                          hasText: _hasText,
                          removeFocus: _removeFocus,
                          onChanged: (text) {
                            setState(() {
                              _hasText = text.isNotEmpty;
                            });
                          },
                          clearSearch: _clearSearch,
                        ),
                      ),
                      SizedBox(width: 12),
                      Padding(
                        padding: const EdgeInsets.only(right: 4, top: 40, bottom: 8),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.cast, size: 23, color: AppColors.lightGrey),
                        ),
                      ),
                    ],
                  ),
                  if (!_isTabLoading && _hasText && !_isLoading && !_isSearchResult)
                    SearchResults(
                      isLoading: _isLoading,
                      noResultsFound: _noResultsFound,
                      hasText: _hasText,
                      searchResults: _searchResults,
                      onResultTap: _onResultTap,
                    ),
                  if (_isTabLoading)
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: const Center(
                        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
                      ),
                    ),
                  if (!_hasFocus && _searchResults.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {},
                        child: Text('Recent searches', style: TextStyle(fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  if (!_hasText && (_hasFocus || (_noResultsFound && !_isLoading && !_hasText)))
                    Center(child: const SearchPrompt()),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary))),
                ],
              ),
              if (!_isLoading && !_hasFocus && !_noResultsFound)
                GenreGrid(sectionTitle: "Vibes", initialIndex: widget.initialIndex),
            ],
          ),
          if (!_isTabLoading && _isSearchResult && _showTabBarWidget)
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: TabBarWidget(initialIndex: 0),
            ),
          Positioned(
            top: kToolbarHeight + 30,
            left: 0,
            right: 0,
            bottom: 0,
            child: Align(alignment: Alignment.topCenter, child: InternetAwareScreen(title: 'Search Screen', connectedScreen: Container())),
          ),
        ],
      ),
    );
  }
}
