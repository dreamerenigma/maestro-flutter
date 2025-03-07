import 'package:flutter/material.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import '../items/user_message_item.dart';

class UserMessageList extends StatelessWidget {
  final int initialIndex;

  const UserMessageList({super.key, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> messages = [
      {
        'userName': 'John Doe',
        'message': 'Hey! How are you?',
        'timeAgo': '2 minutes ago',
      },
      {
        'userName': 'Jane Smith',
        'message': 'Good morning!',
        'timeAgo': '1 hour ago',
      },
      {
        'userName': 'Sam Johnson',
        'message': 'Check out this link.',
        'timeAgo': 'Yesterday',
      },
      {
        'userName': 'Sam Johnson',
        'message': 'Check out this link.',
        'timeAgo': 'Yesterday',
      },
      {
        'userName': 'Sam Johnson',
        'message': 'Check out this link.',
        'timeAgo': 'Yesterday',
      },
      {
        'userName': 'Sam Johnson',
        'message': 'Check out this link.',
        'timeAgo': 'Yesterday',
      },
    ];

    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: Expanded(
        child: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final messageData = messages[index];
            return UserMessageItem(
              userName: messageData['userName']!,
              message: messageData['message']!,
              timeAgo: messageData['timeAgo']!,
              initialIndex: initialIndex,
            );
          },
        ),
      ),
    );
  }
}
