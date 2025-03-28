import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maestro/features/utils/widgets/no_glow_scroll_behavior.dart';
import '../../../../data/services/user/user_firebase_service.dart';
import '../../../../domain/entities/user/user_entity.dart';
import '../../../../service_locator.dart';
import '../lists/user_list.dart';

class UsersTab extends StatefulWidget {
  final int initialIndex;
  final String searchKeyword;

  const UsersTab({super.key, required this.initialIndex, required this.searchKeyword});

  @override
  UsersTabState createState() => UsersTabState();
}

class UsersTabState extends State<UsersTab> {
  late List<UserEntity> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void didUpdateWidget(covariant UsersTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchKeyword != oldWidget.searchKeyword) {
      _loadUsers();
    }
  }

  Future<void> _loadUsers() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    final result = await sl<UserFirebaseService>().getUsers(user.uid);

    result.fold(
      (error) {
        log('Error: $error');
      },
      (users) {
        final filteredUsers = users.map((userModel) => UserEntity.fromUserModel(userModel)).where((user) {
          return widget.searchKeyword.isEmpty || user.name.toLowerCase().contains(widget.searchKeyword.toLowerCase());
        }).toList();

        if (filteredUsers != _users) {
          setState(() {
            _users = filteredUsers;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: Column(
          children: [
            Expanded(
              child: UserList(users: _users, initialIndex: widget.initialIndex, shouldShowToResultRow: false),
            ),
          ],
        ),
      ),
    );
  }
}
