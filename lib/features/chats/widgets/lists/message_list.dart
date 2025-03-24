import 'package:flutter/material.dart';
import '../../../../domain/entities/user/user_entity.dart';
import '../../models/message_model.dart';
import '../messages/recipient_message.dart';
import '../messages/sender_message.dart';

class MessageList extends StatefulWidget {
  final int initialIndex;
  final String currentUserId;
  final List<MessageModel> messages;
  final UserEntity user;

  const MessageList({
    super.key,
    required this.currentUserId,
    required this.messages,
    required this.user,
    required this.initialIndex,
  });

  @override
  MessageListState createState() => MessageListState();
}

class MessageListState extends State<MessageList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void didUpdateWidget(covariant MessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length != oldWidget.messages.length) {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final message = widget.messages[index];
        final isMe = message.fromId == widget.currentUserId;

        return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: isMe ? SenderMessage(message: message) : RecipientMessage(message: message, initialIndex: widget.initialIndex, user: widget.user),
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }
}
