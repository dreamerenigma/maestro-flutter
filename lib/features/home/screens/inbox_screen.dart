import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:get_storage/get_storage.dart';
import 'package:maestro/common/widgets/app_bar/app_bar.dart';
import 'package:maestro/utils/constants/app_sizes.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../api/apis.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../generated/l10n/l10n.dart';
import '../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../../chats/widgets/lists/user_message_list.dart';
import '../widgets/nav_bar/bottom_nav_bar.dart';
import 'home_screen.dart';
import '../../chats/screens/new_message_screen.dart';

class InboxScreen extends StatefulWidget {
  final int initialIndex;
  final int selectedIndex;
  final Function(int) onItemTapped;
  final Function(int) updateUnreadMessages;

  const InboxScreen({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.updateUnreadMessages,
    required this.initialIndex,
  });

  @override
  State<InboxScreen> createState() => InboxScreenState();
}

class InboxScreenState extends State<InboxScreen> {
  late Future<Map<String, dynamic>?> userDataFuture;
  final GetStorage storage = GetStorage();

  @override
  void initState() {
    super.initState();
    userDataFuture = APIs.fetchUserData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.updateUnreadMessages(0);
    });
  }

  void _buildMarkMessageAsRead() {
    int newUnreadCount = 0;
    widget.updateUnreadMessages(newUnreadCount);
    storage.write('unreadMessages', newUnreadCount);
  }

  Future<void> _reloadData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: BasicAppBar(
            title: Text(S.of(context).inbox, style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.cast, size: 23),
              ),
            ],
          ),
          body: MiniPlayerManager(
            hideMiniPlayerOnSplash: false,
            child: RefreshIndicator(
              onRefresh: _reloadData,
              displacement: 0,
              color: AppColors.primary,
              backgroundColor: context.isDarkMode ? AppColors.youngNight : AppColors.softGrey,
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

                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _buildMarkMessageAsRead();
                          },
                          child: _buildMessage(context, userData),
                        ),
                        Expanded(
                          child: UserMessageList(initialIndex: widget.initialIndex),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
          bottomNavigationBar: BottomNavBar(
            selectedIndex: widget.selectedIndex,
            onItemTapped: (index) {
              Navigator.pushReplacement(context, createPageRoute(HomeScreen(initialIndex: index)));
            },
          ),
        ),
        Positioned(
          right: 16.0,
          bottom: 140,
          child: SizedBox(
            width: 56.0,
            height: 56.0,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(context, createPageRoute(NewMessageScreen(initialIndex: widget.initialIndex, users: [])));
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              splashColor: AppColors.darkerGrey.withAlpha((0.4 * 255).toInt()),
              backgroundColor: context.isDarkMode ? AppColors.white : AppColors.black,
              child: Icon(PhosphorIcons.pencil_simple_light, size: 26, color: context.isDarkMode ? AppColors.black : AppColors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessage(BuildContext context, Map<String, dynamic> userData) {
    final userName = userData['name'] as String?;
    final createdAtTimestamp = userData['createdAt'] as Timestamp?;
    final createdAt = createdAtTimestamp?.toDate();
    String timeAgo = createdAt != null ? timeago.format(createdAt) : 'No date available';

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.white, border: Border.all(color: AppColors.darkGrey, width: 1)),
            child: const Icon(ZondIcons.music_notes, color: AppColors.black),
          ),
          const SizedBox(width: 20.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Row(
                    children: [
                      Text(S.of(context).appName, style: const TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.bold, height: 1)),
                      const SizedBox(width: 8.0),
                      Container(
                        padding: const EdgeInsets.all(2.0),
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.blue),
                        child: const Icon(Icons.check, color: AppColors.white, size: 12.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  S.of(context).helloUserMessage(userName ?? S.of(context).noName),
                  style: const TextStyle(fontSize: AppSizes.fontSizeSm, color: AppColors.grey, height: 1),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
          const SizedBox(width: 8.0),
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Text('· $timeAgo', style: const TextStyle(fontSize: AppSizes.fontSizeLm, color: AppColors.grey)),
          ),
        ],
      ),
    );
  }
}
