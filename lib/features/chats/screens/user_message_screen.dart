import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maestro/features/home/screens/add_track_or_playlist.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import '../../../../common/widgets/app_bar/app_bar.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../data/services/message/message_firebase_service.dart';
import '../../../domain/entities/user/user_entity.dart';
import '../../../service_locator.dart';
import '../../../utils/constants/app_colors.dart';
import '../../home/screens/home_screen.dart';
import '../../home/widgets/nav_bar/bottom_nav_bar.dart';
import '../../song_player/widgets/mini_player/mini_player_manager.dart';
import '../models/message_model.dart';
import '../widgets/inputs/message_text_field.dart';
import '../widgets/lists/message_list.dart';

class UserMessageScreen extends StatefulWidget {
  final int initialIndex;
  final int selectedIndex;
  final UserEntity? user;

  const UserMessageScreen({super.key, required this.initialIndex, required this.selectedIndex, required this.user});

  @override
  State<UserMessageScreen> createState() => _UserMessageScreenState();
}

class _UserMessageScreenState extends State<UserMessageScreen> {
  late final int selectedIndex;
  final TextEditingController _controller = TextEditingController();
  final bool isMiniPlayerVisible = false;
  List<MessageModel> _messages = [];
  String currentText = "";

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  void _onSend(String message) async {
    log('Sending message: $message');
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        log('No user logged in');
        throw Exception('No user logged in');
      }

      if (message.trim().isEmpty) return;

      final sentTimestamp = DateTime.now();

      final messageModel = MessageModel(
        fromId: user.uid,
        toId: widget.user?.id ?? '',
        message: message,
        read: false,
        sent: sentTimestamp,
        deleted: [],
      );

      final result = await sl<MessageFirebaseService>().addMessage(messageModel);

      result.fold(
        (failure) {
          log('Ошибка при отправке сообщения: $failure');
        },
        (sentMessage) {
          log('Сообщение успешно отправлено: ${sentMessage.message}');
          _controller.clear();
        },
      );
    } catch (e) {
      log('Ошибка в _onSend: $e');
    }
  }

  void _onAttach() {
    Navigator.push(context, createPageRoute(AddTrackOrPlaylist()));
  }

  void _onTextChanged(String text) {
    currentText = text;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isKeyboardVisible = mediaQuery.viewInsets.bottom > 0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: BasicAppBar(
        title: Text(widget.user!.name, style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
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
          Positioned.fill(
            child: ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder<List<MessageModel>>(
                      stream: sl<MessageFirebaseService>().getMessages(FirebaseAuth.instance.currentUser!.uid, widget.user?.id ?? ''),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          log('StreamBuilder: waiting for data...');
                          return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)));
                        }

                        if (snapshot.hasError) {
                          log('StreamBuilder: Error - ${snapshot.error}');
                          return Center(child: Text('Ошибка при загрузке сообщений'));
                        }

                        if (!snapshot.hasData || snapshot.data == null) {
                          log('StreamBuilder: No data available');
                          return Center(child: Text('Нет сообщений'));
                        }

                        _messages = snapshot.data!;
                        log('StreamBuilder: Messages updated, count: ${_messages.length}');

                        return MessageList(
                          key: ValueKey(_messages.length),
                          currentUserId: FirebaseAuth.instance.currentUser!.uid,
                          messages: _messages,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: isKeyboardVisible ? 0 + 0 : (isMiniPlayerVisible ? 65 : 0),
            left: 0,
            right: 0,
            child: MessageTextField(controller: _controller, onChanged: _onTextChanged, onSend: _onSend, onAttach: _onAttach),
          ),
          if (!isKeyboardVisible && isMiniPlayerVisible)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: MiniPlayerManager(
                hideMiniPlayerOnSplash: false,
                child: SizedBox(
                  height: 60,
                  child: Center(child: Text('Mini Player Here')),
                ),
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
