import 'package:flutter/material.dart';
import '../../../../domain/entities/user/user_entity.dart';
import '../items/user_item.dart';

class UserList extends StatelessWidget {
  final int initialIndex;
  final List<UserEntity> users;
  final bool shouldShowToResultRow;

  const UserList({
    super.key,
    required this.users,
    required this.initialIndex,
    this.shouldShowToResultRow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (shouldShowToResultRow)
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 6),
          child: Align(
            alignment: Alignment.centerLeft,
            child: const Text('Top Result', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, letterSpacing: -1.3)),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(top: 6),
            itemCount: users.length,
            itemBuilder: (context, index) {
              return UserItem(user: users[index], initialIndex: initialIndex);
            },
          ),
        ),
      ],
    );
  }
}
