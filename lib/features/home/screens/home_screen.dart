import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maestro/features/home/screens/upload_tracks_screen.dart';
import 'package:maestro/utils/constants/app_colors.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../routes/custom_page_route.dart';
import '../../authentication/screens/signin_screen.dart';
import '../../feed/screens/feed_screens.dart';
import '../../library/screens/library_screen.dart';
import '../../search/screens/search_screen.dart';
import '../../song_player/bloc/song_player_cubit.dart';
import '../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../../upgrade/screens/upgrade_screen.dart';
import '../widgets/home_header_widget.dart';
import '../widgets/nav_bar/bottom_nav_bar.dart';
import 'inbox_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;

  const HomeScreen({super.key, this.initialIndex = 0});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  User? _user;
  bool _isLoading = false;
  int unreadMessages = 1;
  File? _selectedFile;

  late AnimationController _rotationController;
  late Animation<double> rotationAnimation;
  late AnimationController _opacityController;
  late Animation<double> opacityAnimation;

  final GetStorage storage = GetStorage();

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _tabController = TabController(length: 5, vsync: this);
    _checkAuthentication();
    _initializeAnimations();
    loadUnreadMessages();
  }

  void _initializeAnimations() {
    _rotationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    rotationAnimation = Tween(begin: 0.0, end: 1.0).animate(_rotationController);

    _opacityController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    opacityAnimation = Tween(begin: 1.0, end: 0.0).animate(_opacityController);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _opacityController.dispose();
    super.dispose();
  }

  void _checkAuthentication() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacement(context, createPageRoute(SignInScreen()));
    } else {
      setState(() {
        _user = user;
      });
    }
  }

  void loadUnreadMessages() {
    int? storedCount = storage.read('unreadMessages');
    if (storedCount != null) {
      setState(() {
        unreadMessages = storedCount;
      });
    }
  }

  void updateUnreadMessages(int count) {
    setState(() {
      unreadMessages = count;
      storage.write('unreadMessages', unreadMessages);
    });
  }

  Future<void> reloadData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  void onUpgradePressed() {
    Navigator.push(
      context,
      createPageRoute(UpgradeScreen()),
    );
  }

  Future<void> requestStoragePermission() async {
    final PermissionStatus status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      log("Permission granted.");
    } else {
      log("Permission denied.");
      openAppSettings();
    }
  }

  void onIconPressed({
    required String title,
    required String artist,
    String description = '',
    String caption = '',
  }) async {
    log("Requesting storage permission...");
    await requestStoragePermission();

    final PermissionStatus permissionStatus = await Permission.manageExternalStorage.status;

    if (permissionStatus.isGranted) {
      log("Storage permission granted.");

      if (!_rotationController.isAnimating) {
        log("Starting animations...");

        setState(() {
          _isLoading = true;
        });

        _rotationController.repeat();
        _opacityController.repeat(reverse: true);

        await Future.delayed(const Duration(seconds: 2));

        if (_selectedFile != null) {
          setState(() {
            _selectedFile = null;
          });
        }

        Navigator.push(
          context,
          createPageRoute(UploadTracksScreen(
            songName: '',
            shouldSelectFileImmediately: true,
            selectedFile: _selectedFile,
          )),
        ).then((_) async {

          if (_selectedFile != null) {
            log("File selected, navigating to UploadTracksScreen...");
            setState(() {
              _isLoading = false;
            });
            _rotationController.stop();
            _opacityController.stop();
          } else {
            log("No file selected.");
            setState(() {
              _isLoading = false;
            });
            _rotationController.stop();
            _opacityController.stop();
          }
        });

      } else {
        log("Rotation controller is already animating.");
      }
    } else {
      log("Storage permission is not granted.");
      openAppSettings();
    }
  }

  void onInboxTapped() {
    Navigator.push(
      context,
      createPageRoute(InboxScreen(
        initialIndex: widget.initialIndex,
        selectedIndex: _selectedIndex,
        onItemTapped: onItemTapped,
        updateUnreadMessages: updateUnreadMessages,
      )),
    );
  }

  void onNotificationsTapped() {
    Navigator.push(
      context,
      createPageRoute(NotificationsScreen(
        selectedIndex: _selectedIndex,
        onItemTapped: onItemTapped,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)));
    }

    return BlocProvider(
      create: (_) => SongPlayerCubit(),
      child: Scaffold(
        body: Stack(
          children: [
            MiniPlayerManager(
              hideMiniPlayerOnSplash: false,
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  HomeScreenWidget(
                    unreadMessages: unreadMessages,
                    isLoading: _isLoading,
                    onUpgradePressed: onUpgradePressed,
                    onIconPressed: () => onIconPressed(title: 'Song Title', artist: 'Song Artist'),
                    onInboxTapped: onInboxTapped,
                    onNotificationsTapped: onNotificationsTapped,
                    selectedIndex: _selectedIndex,
                    onItemTapped: onItemTapped,
                    updateUnreadMessages: updateUnreadMessages,
                    reloadData: reloadData,
                    tabController: _tabController,
                    initialIndex: widget.initialIndex,
                  ),
                  FeedScreen(onUpgradeTapped: () {
                    onItemTapped(4);
                  }),
                  SearchScreen(initialIndex: widget.initialIndex),
                  LibraryScreen(onUpgradeTapped: () {
                    onItemTapped(4);
                  }, audioFiles: const []),
                  UpgradeScreen(),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: kIsWeb ? null : BottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: onItemTapped,
        ),
      ),
    );
  }
}
