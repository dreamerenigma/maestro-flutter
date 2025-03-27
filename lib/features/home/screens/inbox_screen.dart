import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:maestro/common/widgets/app_bar/app_bar.dart';
import 'package:maestro/utils/constants/app_sizes.dart';
import '../../../api/apis.dart';
import '../../../domain/entities/user/user_entity.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_vectors.dart';
import '../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../../chats/widgets/lists/user_message_list.dart';
import '../../utils/screens/internet_aware_screen.dart';
import '../widgets/message_widget.dart';
import '../widgets/nav_bar/bottom_nav_bar.dart';
import 'home_screen.dart';
import '../../chats/screens/new_message_screen.dart';

class InboxScreen extends StatefulWidget {
  final int initialIndex;
  final int selectedIndex;
  final Function(int) onItemTapped;
  final Function(int) updateUnreadMessages;
  final UserEntity? user;

  const InboxScreen({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.updateUnreadMessages,
    required this.initialIndex,
    this.user,
  });

  @override
  State<InboxScreen> createState() => InboxScreenState();
}

class InboxScreenState extends State<InboxScreen> {
  late Future<Map<String, dynamic>?> userDataFuture;
  final GetStorage storage = GetStorage();
  late Stream<List<Map<String, dynamic>>> messageStream;
  bool isMiniPlayerVisible = true;

  double get fabBottomPosition {
    return isMiniPlayerVisible ? 75.0 : 15.0;
  }

  @override
  void initState() {
    super.initState();
    userDataFuture = APIs.fetchUserData();
    messageStream = _fetchUserMessages();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.updateUnreadMessages(0);
    });
    _fetchUserMessages();
    toggleMiniPlayerVisibility();
  }

  void toggleMiniPlayerVisibility() {
    setState(() {
      isMiniPlayerVisible = !isMiniPlayerVisible;
    });
  }

  Stream<List<Map<String, dynamic>>> _fetchUserMessages() async* {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      log("User not logged in");
      yield [];
      return;
    }

    final String userId = user.uid;

    log("Fetching chats for user: $userId");

    yield* FirebaseFirestore.instance
      .collection('Chats')
      .where('fromId', isEqualTo: userId)
      .snapshots()
      .asyncMap((querySnapshot) async {
        log("Fetched chats where user is fromId: ${querySnapshot.docs.length} chats found");

        List<Map<String, dynamic>> messages = [];

        for (final chatDoc in querySnapshot.docs) {
          final chatId = chatDoc.id;
          log("Processing chat: $chatId");

          final messagesSnapshot = await FirebaseFirestore.instance
            .collection('Chats')
            .doc(chatId)
            .collection('Messages')
            .orderBy('sent', descending: true)
            .limit(1)
            .get();

          log("Fetched messages for chat $chatId: ${messagesSnapshot.docs.length} messages found");

          if (messagesSnapshot.docs.isNotEmpty) {
            for (var messageDoc in messagesSnapshot.docs) {
              final data = messageDoc.data();
              log("Message data for chat $chatId: $data");

              final fromId = data['fromId'] ?? '';
              final toId = data['toId'] ?? '';

              if (fromId.isEmpty || toId.isEmpty) {
                log("Error: fromId or toId is empty in chatId: $chatId");
              }

              if (fromId == userId || toId == userId) {
                messages.add({
                  'fromId': fromId,
                  'toId': toId,
                  'message': data['message'] ?? '',
                  'read': data['read'] ?? false,
                  'sent': (data['sent'] as Timestamp).toDate(),
                });
              }
            }
          } else {
            log("No messages found for chatId: $chatId");
          }
        }

        log("Total messages fetched: ${messages.length}");

        final receivedChatsSnapshot = await FirebaseFirestore.instance
          .collection('Chats')
          .where('toId', isEqualTo: userId)
          .get();

        log("Fetched chats where user is toId: ${receivedChatsSnapshot.docs.length} chats found");

        for (final chatDoc in receivedChatsSnapshot.docs) {
          final chatId = chatDoc.id;
          log("Processing received chat: $chatId");

          final messagesSnapshot = await FirebaseFirestore.instance
            .collection('Chats')
            .doc(chatId)
            .collection('Messages')
            .orderBy('sent', descending: true)
            .limit(1)
            .get();

          log("Fetched messages for received chat $chatId: ${messagesSnapshot.docs.length} messages found");

          if (messagesSnapshot.docs.isNotEmpty) {
            for (var messageDoc in messagesSnapshot.docs) {
              final data = messageDoc.data();
              log("Message data for received chat $chatId: $data");

              final fromId = data['fromId'] ?? '';
              final toId = data['toId'] ?? '';

              if (fromId.isEmpty || toId.isEmpty) {
                log("Error: fromId or toId is empty in chatId: $chatId");
              }

              if (fromId == userId || toId == userId) {
                messages.add({
                  'fromId': fromId,
                  'toId': toId,
                  'message': data['message'] ?? '',
                  'read': data['read'] ?? false,
                  'sent': (data['sent'] as Timestamp).toDate(),
                });
              }
            }
          } else {
            log("No messages found for received chatId: $chatId");
          }
        }

        log("Total messages fetched after adding received chats: ${messages.length}");

        return messages;
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
    return Scaffold(
      appBar: BasicAppBar(
        title: Text(S.of(context).inbox, style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cast, size: 22),
          ),
        ],
      ),
      body: Stack(
        children: [
          MiniPlayerManager(
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
                          child: MessageWidget(userData: userData),
                        ),
                        Expanded(
                          child: UserMessageList(initialIndex: widget.initialIndex, messageStream: messageStream),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
          Positioned(
            right: 16.0,
            bottom: fabBottomPosition,
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
                child: SvgPicture.asset(
                  AppVectors.pencil,
                  width: 23,
                  height: 23,
                  colorFilter: ColorFilter.mode(context.isDarkMode ? AppColors.black : AppColors.white, BlendMode.srcIn),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 60,
            child: Align(
              alignment: Alignment.topCenter,
              child: InternetAwareScreen(title: 'Inbox Screen', connectedScreen: Container()),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: widget.selectedIndex,
        onItemTapped: (index) {
          Navigator.pushReplacement(context, createPageRoute(HomeScreen(initialIndex: index)));
        },
      ),
    );
  }
}
