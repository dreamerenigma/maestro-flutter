import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:maestro/features/home/screens/add_track_or_playlist.dart';
import '../../../../common/widgets/app_bar/app_bar.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../home/screens/home_screen.dart';
import '../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../song_player/widgets/mini_player/mini_player_manager.dart';

class UserMessageScreen extends StatefulWidget {
  final int initialIndex;
  final int selectedIndex;
  final String userName;

  const UserMessageScreen({super.key, required this.initialIndex, required this.selectedIndex, required this.userName});

  @override
  State<UserMessageScreen> createState() => _UserMessageScreenState();
}

class _UserMessageScreenState extends State<UserMessageScreen> {
  late final int selectedIndex;
  final TextEditingController _controller = TextEditingController();
  bool get _hasText => _controller.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  void _clearText() {
    setState(() {
      _controller.clear();
    });
  }

@override
Widget build(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  final isKeyboardVisible = mediaQuery.viewInsets.bottom > 0;

  return Scaffold(
    resizeToAvoidBottomInset: true,
    appBar: BasicAppBar(
      title: Text(
        widget.userName,
        style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.cast, size: 23),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert_rounded, size: 23),
        ),
      ],
    ),
    body: Stack(
      children: [
        // Main content
        Positioned.fill(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    children: [], // Add your content here
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: isKeyboardVisible ? 0 + 0 : 65,
          left: 0,
          right: 0,
          child: _buildTextField(context),
        ),

        // MiniPlayerManager as an overlay above the BottomNavBar
        if (!isKeyboardVisible)
          Positioned(
            bottom: 0,  // Adjust this position if needed
            left: 0,
            right: 0,
            child: MiniPlayerManager(
              hideMiniPlayerOnSplash: false,
              child: SizedBox(
                height: 60, // Adjust height as needed
                child: Center(child: Text('Mini Player Here')),
              ),
            ),
          ),
      ],
    ),

    // Bottom Navigation Bar
    bottomNavigationBar: BottomNavBar(
      selectedIndex: widget.selectedIndex,
      onItemTapped: (index) {
        Navigator.pushReplacement(context, createPageRoute(HomeScreen(initialIndex: index)));
      },
    ),
  );
}


  Widget _buildTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: 45,
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
                    controller: _controller,
                    cursorColor: AppColors.primary,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (text) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).brightness == Brightness.dark ? AppColors.darkGrey : AppColors.grey.withAlpha((0.2 * 255).toInt()),
                      hintText: 'Type your message',
                      hintStyle: TextStyle(fontSize: AppSizes.fontSizeMd, color: context.isDarkMode ? AppColors.darkerGrey : AppColors.darkerGrey),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.symmetric(vertical: 14.0),
                      prefixIcon: IconButton(
                        icon: Icon(
                          Icons.attach_file_outlined,
                          color: Theme.of(context).brightness == Brightness.dark ? AppColors.white : AppColors.black,
                        ),
                        onPressed: () {
                          Navigator.push(context, createPageRoute(AddTrackOrPlaylist()));
                        },
                      ),
                      suffixIcon: _controller.text.isNotEmpty ?
                        IconButton(
                          onPressed: _clearText,
                          icon: Icon(Ionicons.close_circle, size: 26, color: context.isDarkMode ? AppColors.lightGrey : AppColors.darkGrey),
                        )
                      : null,
                    ),
                    style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              if (_hasText)
              Container(
                margin: const EdgeInsets.only(left: 8.0),
                child: CircleAvatar(
                  backgroundColor: context.isDarkMode ? AppColors.white : AppColors.black,
                  radius: 24,
                  child: IconButton(
                    icon: Icon(CarbonIcons.send_alt, color: context.isDarkMode ? AppColors.black : AppColors.white, size: 30),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
