import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:maestro/features/home/screens/add_track_or_playlist_screen.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import '../../../../common/widgets/app_bar/app_bar.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../data/services/message/message_firebase_service.dart';
import '../../../domain/entities/song/song_entity.dart';
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
  final UserEntity? user;
  final String? selectedFileURL;
  final SongEntity? selectedTrack;

  const UserMessageScreen({
    super.key,
    required this.initialIndex,
    required this.user,
    this.selectedFileURL,
    this.selectedTrack,
  });

  @override
  State<UserMessageScreen> createState() => _UserMessageScreenState();
}

class _UserMessageScreenState extends State<UserMessageScreen> {
  late final int selectedIndex;
  final TextEditingController _controller = TextEditingController();
  final bool isMiniPlayerVisible = false;
  List<MessageModel> _messages = [];
  String currentText = "";
  Set<String> selectedTracks = {};
  String fileURL = '';
  bool _showTrackInfo = true;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;

    if (widget.selectedFileURL != null) {
      fileURL = widget.selectedFileURL!;
      _controller.text = fileURL;
      log('Initial fileURL in initState: $fileURL');
    }
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

  void _onFileURLSelected(String selectedFileURL) {
    log('onFileURLSelected triggered with value: $selectedFileURL');
    setState(() {
      fileURL = selectedFileURL;
    });
    log('Updated fileURL in _onFileURLSelected: $fileURL');
  }

  void _onAttach() {
    log('fileURL before navigation: $fileURL');
    if (fileURL.isEmpty) {
      log('fileURL is empty before navigating');
    }

    log('Navigation Stack');

    Navigator.push(
      context,
      createPageRoute(
        AddTrackOrPlaylistScreen(
          initialIndex: 0,
          onFileURLSelected: _onFileURLSelected,
          initialFileURL: fileURL,
          user: widget.user,
        ),
      ),
    );
  }

  void _clearText() {
    _controller.clear();
    setState(() {
      _showTrackInfo = false;
    });
  }

  void _onTextChanged(String text) {
    currentText = text;
  }

  void _hideTrackInfo() {
    _controller.clear();
    setState(() {
      _showTrackInfo = false;
    });
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
            icon: const Icon(Icons.cast, size: 22),
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

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 62),
                          child: MessageList(
                            key: ValueKey(_messages.length),
                            currentUserId: FirebaseAuth.instance.currentUser!.uid,
                            messages: _messages,
                            user: widget.user!,
                            initialIndex: widget.initialIndex,
                          ),
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
            child: Container(
              color: Theme.of(context).brightness == Brightness.dark ? AppColors.backgroundColor : AppColors.white,
              child: Column(
                children: [
                  _buildTrackInfo(),
                  MessageTextField(
                    controller: _controller,
                    onChanged: _onTextChanged,
                    onSend: _onSend,
                    onAttach: _onAttach,
                    onInsertFileURL: (url) {
                      _controller.text = '$fileURL $url';
                    },
                    onClearText: _clearText,
                  ),
                ],
              ),
            ),
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
        selectedIndex: selectedIndex,
        onItemTapped: (index) {
          Navigator.pushReplacement(context, createPageRoute(HomeScreen(initialIndex: index)));
        },
      ),
    );
  }

  Widget _buildTrackInfo() {
    if (widget.selectedTrack != null && _showTrackInfo) {
      SongEntity track = widget.selectedTrack!;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkGrey : AppColors.lightGrey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 8, top: 10, bottom: 10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    track.cover,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(track.title, style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(track.uploadedBy, style: TextStyle(color: AppColors.darkerGrey)),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Ionicons.close_circle, size: 24, color: AppColors.darkerGrey),
                  onPressed: _hideTrackInfo,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
