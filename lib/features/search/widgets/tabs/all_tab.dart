import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maestro/data/services/playlist/playlist_firebase_service.dart';
import '../../../../data/services/song/song_firebase_service.dart';
import '../../../../data/services/user/user_firebase_service.dart';
import '../../../../domain/entities/playlist/playlist_entity.dart';
import '../../../../domain/entities/song/song_entity.dart';
import '../../../../domain/entities/user/user_entity.dart';
import '../../../../service_locator.dart';
import '../../../utils/widgets/no_glow_scroll_behavior.dart';
import '../lists/user_list.dart';

class AllTab extends StatefulWidget {
  final int initialIndex;
  final String searchKeyword;

  const AllTab({super.key, required this.initialIndex, required this.searchKeyword});

  @override
  State<AllTab> createState() => _AllTabState();
}

class _AllTabState extends State<AllTab> {
  late List<UserEntity> _users = [];
  late List<SongEntity> _songs = [];
  late List<PlaylistEntity> _playlists = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void didUpdateWidget(covariant AllTab oldWidget) {
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

    final userResult = await sl<UserFirebaseService>().getUsers(user.uid);

    userResult.fold(
      (error) {
        log('Error fetching users: $error');
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

    final songResult = await sl<SongFirebaseService>().getSong();

    songResult.fold(
      (error) {
        log('Error fetching songs: $error');
      },
      (songs) {
        final filteredSongs = songs.map((songModel) => PlaylistEntity.fromPlaylistModel(songModel)).where((song) {
          return widget.searchKeyword.isEmpty || song.title.toLowerCase().contains(widget.searchKeyword.toLowerCase());
        }).toList();

        if (filteredSongs != _songs) {
          setState(() {
            _songs = filteredSongs;
          });
        }
      },
    );

    final playlistResult = await sl<PlaylistFirebaseService>().getPlayList();

    playlistResult.fold(
      (error) {
        log('Error fetching playlists: $error');
      },
      (playlists) {
        final filteredPlaylists = playlists.map((playlistModel) => PlaylistEntity.fromPlaylistModel(playlistModel)).where((playlist) {
          return widget.searchKeyword.isEmpty || playlist.title.toLowerCase().contains(widget.searchKeyword.toLowerCase());
        }).toList();

        if (filteredPlaylists != _playlists) {
          setState(() {
            _playlists = filteredPlaylists;
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
              child: UserList(users: _users, initialIndex: widget.initialIndex, shouldShowToResultRow: true),
            ),
          ],
        ),
      ),
    );
  }
}
