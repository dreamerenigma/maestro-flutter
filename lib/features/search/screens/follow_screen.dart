import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:maestro/utils/constants/app_sizes.dart';
import '../../../api/apis.dart';
import '../../../data/services/history/history_firebase_service.dart';
import '../../../domain/entities/user/user_entity.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../service_locator.dart';
import '../../../utils/constants/app_colors.dart';
import '../../home/screens/home_screen.dart';
import '../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../library/widgets/dialogs/show_more_bio_info_bottom_dialog.dart';
import '../../library/widgets/icons/action_icons_widget.dart';
import '../../library/widgets/icons/fixed_icons_widget.dart';
import '../../library/widgets/user_avatar_widget.dart';
import '../../library/widgets/user_info_widget.dart';
import '../../library/widgets/user_profile_info_widget.dart';
import '../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../../utils/widgets/no_glow_scroll_behavior.dart';
import '../controllers/user_params_controller.dart';

class FollowScreen extends StatefulWidget {
  final int initialIndex;
  final UserEntity? user;

  const FollowScreen({super.key, required this.initialIndex, required this.user});

  @override
  State<FollowScreen> createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen> {
  final GetStorage _storageBox = GetStorage();
  late Future<Map<String, dynamic>?> userDataFuture;
  late ScrollController scrollController;
  final ValueNotifier<double> opacityNotifier = ValueNotifier<double>(1.0);
  late final int selectedIndex;
  String? _imageUrlBg;
  bool isShuffleActive = false;
  bool isConnected = true;
  RxBool isFollowing = false.obs;
  bool isBlocked = false;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    userDataFuture = APIs.fetchUserData();
    scrollController = ScrollController();
    final userParamsController = Get.find<UserParamsController>();
    userParamsController.setUserParams('currentUserId', 'targetUserId');

    scrollController.addListener(() {
      double newOpacity = (1 - (scrollController.offset / 100)).clamp(0.0, 1.0);
      opacityNotifier.value = newOpacity;
    });

    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      setState(() {
        isConnected = result != ConnectivityResult.none;
      });
    });

    _checkIfBlocked();
    _checkInternetConnection();
    _loadRecentlyPlayed();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _checkInternetConnection() async {
    bool hasConnection;
    try {
      final result = await InternetAddress.lookup('google.com');
      hasConnection = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      hasConnection = false;
    }
    setState(() {
      isConnected = hasConnection;
    });
  }

  void _loadRecentlyPlayed() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      log('No current user');
      return;
    }

    if (widget.user != null) {
      final userData = {
        'image': widget.user?.image,
        'name': widget.user?.name,
        'followers': widget.user?.followers,
      };

      await sl<HistoryFirebaseService>().addToRecentlyPlayed(userData, 'user');
    }
  }

  void _checkIfBlocked() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    if (widget.user == null) {
      log('Error: user is null.');
      return;
    }

    if (widget.user!.id == null || widget.user!.id.isEmpty) {
      log('Error: user id is null or empty.');
      return;
    }

    final currentUserId = user.uid;
    final targetUserId = widget.user!.id;

    final blockedUsersRef = FirebaseFirestore.instance.collection('Users').doc(currentUserId).collection('BlockedUsers');
    final doc = await blockedUsersRef.doc(targetUserId).get();

    if (doc.exists) {
      setState(() {
        isBlocked = true;
      });
    } else {
      setState(() {
        isBlocked = false;
      });
    }
  }

  void toggleShuffle() {
    setState(() {
      isShuffleActive = !isShuffleActive;
    });
    _storageBox.write('isShuffleActive', isShuffleActive);
  }

  Future<void> _reloadData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MiniPlayerManager(
        hideMiniPlayerOnSplash: false,
        child: FutureBuilder<Map<String, dynamic>?>(
          future: userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)));
            } else if (snapshot.hasError) {
              return Center(child: Text(S.of(context).errorLoadingProfile));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text(S.of(context).noUserDataFound));
            } else {
              final userData = snapshot.data!;

              return SafeArea(
                child: Stack(
                  children: [
                    ScrollConfiguration(
                      behavior: NoGlowScrollBehavior(),
                      child: RefreshIndicator(
                        onRefresh: _reloadData,
                        displacement: 0,
                        color: AppColors.primary,
                        backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.softGrey,
                        child: CustomScrollView(
                          controller: scrollController,
                          slivers: [
                            if (isConnected)
                            SliverAppBar(
                              pinned: true,
                              floating: false,
                              backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.backgroundColor : AppColors.white,
                              title: ValueListenableBuilder<double>(
                                valueListenable: opacityNotifier,
                                builder: (context, opacity, child) {
                                  return Opacity(opacity: opacity, child: child!);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(widget.user!.name, style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? AppColors.white : AppColors.black, fontSize: 20)),
                                ),
                              ),
                            ),
                            if (isConnected)
                            SliverList(
                              delegate: SliverChildListDelegate(
                                [
                                  _buildBackground(context),
                                  const SizedBox(height: 50),
                                  _buildUserProfile(userData),
                                  ActionIconsWidget(
                                    isShuffleActive: isShuffleActive,
                                    toggleShuffle: toggleShuffle,
                                    initialIndex: widget.initialIndex,
                                    showEditProfileButton: false,
                                    showFollowButton: true,
                                    showDeleteHistory: false,
                                    isFollowing: isFollowing,
                                    user: widget.user,
                                  ),
                                  if (widget.user!.bio.isNotEmpty && !isBlocked)
                                  UserInfoWidget(
                                    userData: userData,
                                    getInfoText: (userData) {
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 18, right:18, top: 16),
                                        child: Text(
                                          widget.user!.bio,
                                          style: TextStyle(fontSize: 15, height: 1.2, letterSpacing: -0.3),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,
                                        ),
                                      );
                                    },
                                    onShowMorePressed: (context, userData) {
                                      showMoreBioInfoBottomDialog(context, userData, widget.user);
                                    },
                                  ),
                                  SizedBox(height: 50),
                                  if (isBlocked)
                                  Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 25),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text('Nothing to hear here', style: TextStyle(fontSize: AppSizes.fontSizeLg, fontWeight: FontWeight.bold)),
                                          SizedBox(height: 4),
                                          Text('Follow ${widget.user?.name} for updates on sounds they share in the future.',
                                            style: TextStyle(fontSize: AppSizes.fontSizeSm), textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    FixedIconsWidget(
                      userData: userData,
                      user: widget.user,
                      isStartStation: true.obs,
                      isFollow: true.obs,
                      isMissingMusic: true.obs,
                      isReport: true.obs,
                      isBlockUser: true.obs,
                    ),
                  ],
                ),
              );
            }
          },
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
  
  Widget _buildBackground(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        image: _imageUrlBg != null ? DecorationImage(image: NetworkImage(_imageUrlBg!), fit: BoxFit.cover) : null,
        color: _imageUrlBg == null ? AppColors.transparent : (Theme.of(context).brightness == Brightness.dark ? AppColors.darkGrey : AppColors.lightBackground),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 70,
            left: 20,
            child: UserAvatar(imageUrl: widget.user!.image),
          ),
        ],
      ),
    );
  }
  
  Widget _buildUserProfile(Map<String, dynamic> userData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          UserProfileInfo(
            userName: widget.user!.name,
            city: widget.user!.city,
            country: widget.user!.country,
            initialIndex: widget.initialIndex,
          ),
        ],
      ),
    );
  }
}
