import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestro/domain/entities/user/user_entity.dart';
import '../../../data/services/search/search_firebase_service.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_colors.dart';
import '../../utils/screens/internet_aware_screen.dart';
import '../../../test/fake_query_document_snapshot.dart';
import '../widgets/inputs/search_text_field.dart' as search;
import '../widgets/bars/tab_bar_widget.dart';
import '../widgets/grids/genre_grid.dart';
import '../widgets/items/search_history_item.dart';
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
  UserEntity? user;
  final FocusNode _focusNode = FocusNode();
  bool _hasFocus = false;
  bool _hasText = false;
  bool _isTabLoading = false;
  bool _isSearchResult = false;
  bool _showTabBarWidget = false;
  final TextEditingController _searchController = TextEditingController();
  final SearchService _searchService = SearchService();
  List<QueryDocumentSnapshot> _searchResults = [];
  List<Map<String, dynamic>> _searchHistory = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadSearchHistory();
    _tabController = TabController(length: 5, vsync: this);
    _loadUserData();

    _focusNode.addListener(() {
      log('Focus changed: hasFocus = ${_focusNode.hasFocus}');
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

      log('Before search: hasFocus = ${_focusNode.hasFocus}');

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

      log('After search: hasFocus = ${_focusNode.hasFocus}');

      if (!_focusNode.hasFocus) {
        FocusScope.of(context).requestFocus(_focusNode);
      }
    });
  }

  @override
  void dispose() {
    log('Disposing SearchScreen');
    _tabController.dispose();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SearchScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_hasText && !_focusNode.hasFocus) {
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  Future<void> _loadUserData() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('Users').doc(firebaseUser.uid).get();

      user = UserEntity.fromFirestore(doc);

      setState(() {});
    } else {
      log('No user is logged in');
    }
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
    FocusScope.of(context).requestFocus(_focusNode);
    setState(() {
      _hasText = false;
      _noResultsFound = false;
      _isSearchResult = false;
      _showTabBarWidget = false;
    });
  }

  void _removeFocus() {
    log('Removing focus');
    _focusNode.unfocus();
    setState(() {
      _hasFocus = false;
      _searchResults.clear();
    });
  }

  void _onResultTap(dynamic result) async {
    log('Result tapped: ${result.data()}');

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
        throw Exception('No user logged in');
      }

    Map<String, dynamic> data = result.data() as Map<String, dynamic>;

    String id = result.id;
    String name = data['name'] ?? data['title'] ?? 'Unknown';
    String image = data['image'] ?? data['cover'] ?? '';
    String type = data['type'] ?? '';

    await FirebaseFirestore.instance
      .collection('Users')
      .doc(user.uid)
      .collection('SearchHistory')
      .doc(id)
      .set({ 'id': id, 'name': name, 'image': image, 'timestamp': FieldValue.serverTimestamp(), 'type': type });

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

  Future<void> _loadSearchHistory() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      log('No user logged in');
      return;
    }

    var snapshot = await FirebaseFirestore.instance
      .collection('Users')
      .doc(user.uid)
      .collection('SearchHistory')
      .orderBy('timestamp', descending: true)
      .get();

    setState(() {
      _searchHistory = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  void _deleteSearchHistory(String id) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      log('No user logged in');
      return;
    }

    await FirebaseFirestore.instance.collection('Users').doc(user.uid).collection('SearchHistory').doc(id).delete();

    _loadSearchHistory();
  }

  Future<void> _reloadData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _searchResults.isEmpty ? _buildEmptySearchResults() : _buildSearchResults(),
    );
  }

  Widget _buildSearchResults() {
    return Stack(
      children: [
        Column(
          children: [
            _buildSearchTextField(),
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
                child: const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary))),
              ),
            if (!_hasText && _hasFocus && _searchHistory.isNotEmpty && !(_isSearchResult && !_isTabLoading && _showTabBarWidget))
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
        if (!_isTabLoading && _isSearchResult && _showTabBarWidget)
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: TabBarWidget(initialIndex: 0, searchKeyword: _searchController.text),
          ),
        Positioned(
          top: kToolbarHeight + 30,
          left: 0,
          right: 0,
          bottom: 0,
          child: Align(alignment: Alignment.topCenter, child: InternetAwareScreen(title: 'Search Screen', connectedScreen: Container())),
        ),
      ],
    );
  }

  Widget _buildEmptySearchResults() {
    return RefreshIndicator(
      onRefresh: _reloadData,
      displacement: 100,
      color: AppColors.primary,
      backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.softGrey,
      child: Stack(
        children: [
          Column(
            children: [
              _buildSearchTextField(),
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
                  child: const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary))),
                ),
              if (!_hasText && _hasFocus && _searchHistory.isNotEmpty)
                Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 6),
                          child: Text('Recent searches', style: TextStyle(fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _searchHistory.length,
                      itemBuilder: (context, index) {
                        var item = _searchHistory[index];
                        return SearchHistoryItem(
                          item: item,
                          onDelete: () => _deleteSearchHistory(item['id']),
                          onTap: () => _onResultTap(FakeDocumentSnapshot(item)),
                          initialIndex: widget.initialIndex,
                          user: user,
                        );
                      },
                    ),
                  ],
                ),
              if (!_hasText && _hasFocus && _searchHistory.isEmpty && !_isLoading)
                Center(child: const SearchPrompt()),
              if (_isLoading)
                const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary))),
            ],
          ),
          if (!_isTabLoading && _isSearchResult && _showTabBarWidget)
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: TabBarWidget(initialIndex: 0, searchKeyword: _searchController.text),
            ),
          if (!_isLoading && !_hasFocus && !_noResultsFound)
            Positioned.fill(top: 90, child: GenreGrid(sectionTitle: "Vibes", initialIndex: widget.initialIndex)),
        ],
      ),
    );
  }

  Widget _buildSearchTextField() {
    return Row(
      children: [
        Expanded(
          child: search.SearchTextField(
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
            icon: Icon(Icons.cast, size: 22, color: AppColors.lightGrey),
          ),
        ),
      ],
    );
  }
}
