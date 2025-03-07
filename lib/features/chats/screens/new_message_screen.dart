import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../library/widgets/input_fields/input_field.dart';
import '../../utils/widgets/no_glow_scroll_behavior.dart';
import '../../home/models/user_model.dart';
import '../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../home/screens/home_screen.dart';

class NewMessageScreen extends StatefulWidget {
  final List<UserModel> users;
  final int initialIndex;

  const NewMessageScreen({super.key, required this.initialIndex, required this.users});

  @override
  State<NewMessageScreen> createState() => _NewMessageScreenState();
}

class _NewMessageScreenState extends State<NewMessageScreen> {
  late final int selectedIndex;
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> filteredUsers = [];
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    filteredUsers = widget.users;
    _searchController.addListener(_filterUsers);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  void _filterUsers() {
    setState(() {
      filteredUsers = widget.users.where((user) => user.name.toLowerCase().contains(_searchController.text.toLowerCase())).toList();
    });
  }

  Future<void> _reloadData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  Future<List<UserModel>> fetchUsersFromFirestore() async {
    final usersCollection = FirebaseFirestore.instance.collection('Users');
    final querySnapshot = await usersCollection.get();

    return querySnapshot.docs.map((doc) {
      return UserModel.fromMap(doc.data(), doc.id);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: const Text('New message', style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.cast, size: 23, color: AppColors.lightGrey),
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: RefreshIndicator(
          onRefresh: _reloadData,
          displacement: 0,
          color: AppColors.primary,
          backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.softGrey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 12),
                child: InputField(
                  controller: _searchController,
                  showIcon: false,
                  focusNode: _focusNode,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: (index) {
          Navigator.pushReplacement(context, createPageRoute(HomeScreen(initialIndex: index)));
        },
      ),
    );
  }
}
