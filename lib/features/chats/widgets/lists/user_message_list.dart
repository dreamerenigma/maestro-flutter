import 'package:flutter/material.dart';
import '../../../../generated/l10n/l10n.dart';
import '../items/user_message_item.dart';

class UserMessageList extends StatelessWidget {
  final int initialIndex;
  final List<Map<String, dynamic>> messages;
  final Stream<List<Map<String, dynamic>>> messageStream;

  const UserMessageList({super.key, required this.initialIndex, required this.messages, required this.messageStream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: messageStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text(S.of(context).errorLoadingMessages));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text(S.of(context).noMessages));
        } else {
          final messages = snapshot.data!;

          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return UserMessageItem(
                message: messages[index]['message'] ?? '',
                sent: messages[index]['sent'] ?? '',
                user: messages[index]['userEntity'],
                userName: messages[index]['name'] ?? 'Unknown',
                initialIndex: initialIndex,
              );
            },
          );
        }
      },
    );
  }
}
