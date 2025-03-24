import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maestro/data/services/playlist/playlist_firebase_service.dart';
import '../../../../data/models/playlist/playlist_model.dart';
import '../../../../data/services/user/user_firebase_service.dart';
import '../../../../domain/entities/user/user_entity.dart';
import '../../../../service_locator.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../lists/user_list.dart';

class AllTab extends StatefulWidget {
  final int initialIndex;
  final String searchQuery;

  const AllTab({super.key, required this.initialIndex, required this.searchQuery});

  @override
  State<AllTab> createState() => _AllTabState();
}

class _AllTabState extends State<AllTab> {
  late List<UserEntity> _users = [];
  late List<PlaylistModel> _playlists = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    final result = await sl<UserFirebaseService>().getUsers(user.uid);

    result.fold(
      (error) {
        log('Error fetching users: $error');
      },
      (users) {
        setState(() {
          _users = users.map((userModel) => UserEntity.fromUserModel(userModel)).toList();
        });
      },
    );

    final playlistResult = await sl<PlaylistFirebaseService>().getPlayList();

    playlistResult.fold(
      (error) {
        log('Error fetching playlists: $error');
      },
      (playlists) {
        setState(() {
          _playlists = playlists;
        });
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
              child: UserList(users: _users, initialIndex: widget.initialIndex, shouldShowToResultRow: true),
            ),
          ],
        ),
      ),
    );
  }
}
