import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/search/search_service.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_colors.dart';
import '../../utils/screens/internet_aware_screen.dart';
import '../widgets/bars/search_bar.dart' as search;
import '../widgets/grids/genre_grid.dart';
import '../widgets/texts/search_results.dart';
import '../widgets/texts/search_prompt.dart';

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
  bool _isTabLoading = false;
  int _currentTabIndex = 0;
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
        var searchResults = await _searchService.searchByKeyword(_searchController.text);
        log('Search results: ${searchResults.length}');

        setState(() {
          _searchResults = searchResults;
          _noResultsFound = _searchResults.isEmpty;
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

  void _onResultTap(QueryDocumentSnapshot result) {
    setState(() {
      _isTabLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isTabLoading = false;
      });
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
                              focusNode: _focusNode,
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
                      if (_hasText && !_isLoading)
                        SearchResults(
                          isLoading: _isLoading,
                          noResultsFound: _noResultsFound,
                          hasText: _hasText,
                          searchResults: _searchResults,
                          onResultTap: _onResultTap,
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
                  SizedBox(height: 60),
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
                          focusNode: _focusNode,
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
                  if (_hasText && !_isLoading)
                    SearchResults(
                      isLoading: _isLoading,
                      noResultsFound: _noResultsFound,
                      hasText: _hasText,
                      searchResults: _searchResults,
                      onResultTap: _onResultTap,
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
              SizedBox(height: 60),
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
    );
  }

  Widget _buildTabBar() {
    return DefaultTabController(
      length: 4,
      initialIndex: _currentTabIndex,
      child: Column(
        children: [
          TabBar(
            onTap: (index) {
              setState(() {
                _currentTabIndex = index;
              });
            },
            tabs: const [
              Tab(text: 'Tab 1'),
              Tab(text: 'Tab 2'),
              Tab(text: 'Tab 3'),
              Tab(text: 'Tab 4'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildTabContent('Content 1'),
                _buildTabContent('Content 2'),
                _buildTabContent('Content 3'),
                _buildTabContent('Content 4'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(String content) {
    return Center(child: Text(content));
  }
}
