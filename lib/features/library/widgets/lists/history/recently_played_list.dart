import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:maestro/features/library/screens/library/playlists/playlist_screen.dart';
import 'package:maestro/features/search/screens/follow_screen.dart';
import '../../../../../domain/entities/playlist/playable_item.dart';
import '../../../../../domain/entities/playlist/playlist_entity.dart';
import '../../../../../domain/entities/user/user_entity.dart';
import '../../../../../routes/custom_page_route.dart';
import '../../../../home/widgets/items/recently_played_home_item.dart';
import '../../../../search/widgets/items/user_item.dart';
import '../../../screens/recently_played_screen.dart';
import '../../items/playlist_item.dart';
import '../../items/recently_played_item.dart';
import '../row/tracks_list_row.dart';

class RecentlyPlayedList extends StatefulWidget {
  final int initialIndex;
  final List<PlayableItem> users;
  final Map<String, dynamic> userData;
  final bool shouldShowRecentlyPlayedListRow;
  final bool isEditMode;
  final bool showRecentlyPlayedHomeItem;
  final bool showRecentlyPlayedItem;

  const RecentlyPlayedList({
    super.key,
    required this.initialIndex,
    required this.users,
    required this.userData,
    this.isEditMode = false,
    this.shouldShowRecentlyPlayedListRow = true,
    this.showRecentlyPlayedHomeItem = false,
    this.showRecentlyPlayedItem = false,
  });

  @override
  State<RecentlyPlayedList> createState() => _RecentlyPlayedListState();
}

class _RecentlyPlayedListState extends State<RecentlyPlayedList> {
  List<Map<String, dynamic>> playlists = [];

  @override
  Widget build(BuildContext context) {
    if (widget.users.isEmpty) {
      return const SizedBox.shrink();
    }

    final userEntities = widget.users.whereType<UserEntity>().toList();
    final playlistEntities = widget.users.whereType<PlaylistEntity>().toList();

    log("Total playlists: ${playlistEntities.length}");

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: SizedBox(
        child: Column(
          children: [
            if (widget.shouldShowRecentlyPlayedListRow)
            TracksListRow(
              shouldShow: true,
              songs: userEntities,
              initialIndex: 0,
              title: 'Recently played',
              onPressedSeeAll: () {
                Navigator.push(context, createPageRoute(
                  RecentlyPlayedScreen(initialIndex: 3, playlists: playlists, selectedPlaylistIndex: 0)),
                );
              },
            ),
            if (widget.showRecentlyPlayedItem)
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.users.length > 10 ? 10 : widget.users.length,
                itemBuilder: (context, index) {
                  var item = widget.users[index];

                  if (item is UserEntity) {
                    return UserItem(user: item, initialIndex: widget.initialIndex, hideFollowButton: true);
                  } else if (item is PlaylistEntity) {
                    return PlaylistItem(
                      playlist: {
                        'id': item.id,
                        'title': item.title,
                        'authorName': item.authorName,
                        'coverImage': item.coverImage,
                        'trackCount': item.trackCount,
                        'listenCount': item.listenCount,
                      },
                      isCompactItem: true,
                      onTap: () {
                        int selectedIndex = playlistEntities.indexOf(item);
                        if (selectedIndex == -1) selectedIndex = 0;

                        Navigator.push(
                          context,
                          createPageRoute(
                            PlaylistScreen(
                              initialIndex: widget.initialIndex,
                              playlist: playlistEntities.map((playlist) {
                                return {
                                  'id': playlist.id,
                                  'title': playlist.title,
                                  'authorName': playlist.authorName,
                                  'coverImage': playlist.coverImage,
                                  'isPublic': playlist.isPublic,
                                  'releaseDate': playlist.releaseDate,
                                };
                              }).toList(),
                              selectedPlaylistIndex: selectedIndex,
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            if (widget.showRecentlyPlayedHomeItem)
            GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.4,
              ),
              itemCount: widget.users.length > 4 ? 4 : widget.users.length,
              itemBuilder: (context, index) {
                var item = widget.users[index];

                if (item is UserEntity) {
                  return RecentlyPlayedHomeItem(
                    isPlaylist: false,
                    isStations: false,
                    isUserAvatar: true,
                    imageUrl: item.image,
                    userName: item.name,
                    city: item.city,
                    country: item.country,
                    onTap: () {
                      Navigator.push(context, createPageRoute(FollowScreen(initialIndex: widget.initialIndex, user: item)));
                    },
                  );
                } else if (item is PlaylistEntity) {
                  return RecentlyPlayedHomeItem(
                    isPlaylist: true,
                    isStations: false,
                    isUserAvatar: false,
                    imageUrl: item.coverImage,
                    userName: item.title,
                    authorName: item.authorName,
                    onTap: () {
                      int selectedIndex = playlistEntities.indexOf(item);
                      if (selectedIndex == -1) selectedIndex = 0;

                      Navigator.push(
                        context,
                        createPageRoute(
                          PlaylistScreen(
                            initialIndex: widget.initialIndex,
                            playlist: playlistEntities.map((playlist) => {
                              'id': playlist.id,
                              'title': playlist.title,
                              'authorName': playlist.authorName,
                              'coverImage': playlist.coverImage,
                              'isPublic': playlist.isPublic,
                              'releaseDate': playlist.releaseDate,
                            }).toList(),
                            selectedPlaylistIndex: selectedIndex,
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            if (!widget.showRecentlyPlayedHomeItem && !widget.showRecentlyPlayedItem)
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: 195,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.users.length > 10 ? 10 : widget.users.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, mainAxisSpacing: 10, childAspectRatio: 1.3),
                  padding: EdgeInsets.only(left: 10),
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var item = widget.users[index];

                    if (item is UserEntity) {
                      return RecentlyPlayedItem(
                        isPlaylist: false,
                        isStations: false,
                        isUserAvatar: true,
                        imageUrl: item.image,
                        userName: item.name,
                        userFollowers: item.followers,
                        onTap: () {
                          Navigator.push(context, createPageRoute(FollowScreen(initialIndex: widget.initialIndex, user: item)));
                        },
                      );
                    } else if (item is PlaylistEntity) {
                      return RecentlyPlayedItem(
                        isPlaylist: true,
                        isStations: false,
                        isUserAvatar: false,
                        imageUrl: item.coverImage,
                        userName: item.title,
                        authorName: item.authorName,
                        onTap: () {
                          int selectedIndex = playlistEntities.indexOf(item);
                          if (selectedIndex == -1) selectedIndex = 0;

                          Navigator.push(
                            context,
                            createPageRoute(
                              PlaylistScreen(
                                initialIndex: widget.initialIndex,
                                playlist: playlistEntities.map((playlist) => {
                                  'id': playlist.id,
                                  'title': playlist.title,
                                  'authorName': playlist.authorName,
                                  'coverImage': playlist.coverImage,
                                  'isPublic': playlist.isPublic,
                                  'releaseDate': playlist.releaseDate,
                                }).toList(),
                                selectedPlaylistIndex: selectedIndex,
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
