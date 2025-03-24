import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:maestro/features/search/screens/follow_screen.dart';
import '../../../../../domain/entities/user/user_entity.dart';
import '../../../../../routes/custom_page_route.dart';
import '../../../screens/recently_played_screen.dart';
import '../../items/recently_played_item.dart';
import '../row/tracks_list_row.dart';

class RecentlyPlayedList extends StatelessWidget {
  final int initialIndex;
  final List<UserEntity> users;
  final Map<String, dynamic> userData;
  final bool shouldShowLikesListRow;
  final bool isEditMode;

  const RecentlyPlayedList({
    super.key,
    required this.initialIndex,
    required this.users,
    required this.userData,
    this.isEditMode = false,
    this.shouldShowLikesListRow = true,
  });

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: SizedBox(
        child: Column(
          children: [
            if (shouldShowLikesListRow)
              TracksListRow(
                shouldShow: true,
                songs: users,
                initialIndex: 0,
                title: 'Recently played',
                onPressedSeeAll: () {
                  Navigator.push(context, createPageRoute(RecentlyPlayedScreen(initialIndex: 3)));
                },
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: 195,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: users.length > 10 ? 10 : users.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, mainAxisSpacing: 10, childAspectRatio: 1.3),
                  padding: EdgeInsets.only(left: 10),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var item = users[index];

                    if (item.id.isEmpty) {
                      // log('Error: user id is null or empty for user: ${item.name}');
                    }
                    if (item.image.isEmpty) {
                      // log('Error: user image is null or empty for user: ${item.name}');
                    }
                    if (item.name.isEmpty) {
                      // log('Error: user name is null or empty for user: ${item.id}');
                    }

                    bool isPlaylist = item.image.isNotEmpty;
                    bool isStations = item.name.isNotEmpty;
                    bool isUserAvatar = item.image.isNotEmpty;

                    return RecentlyPlayedItem(
                      isPlaylist: isPlaylist,
                      isStations: isStations,
                      isUserAvatar: isUserAvatar,
                      imageUrl: item.image,
                      userName: item.name,
                      userFollowers: item.followers,
                      onTap: () {
                        Navigator.push(context, createPageRoute(FollowScreen(initialIndex: initialIndex, user: item)));
                      },
                    );
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
