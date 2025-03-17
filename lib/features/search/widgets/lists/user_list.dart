import 'package:flutter/material.dart';
import '../../../../domain/entities/user/user_entity.dart';
import '../items/user_item.dart';

class UserList extends StatelessWidget {
  final int initialIndex;
  final List<UserEntity> users;

  const UserList({super.key, required this.users, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 6),
      itemCount: users.length,
      itemBuilder: (context, index) {

        return UserItem(user: users[index], initialIndex: initialIndex);
      },
    );
  }
}
