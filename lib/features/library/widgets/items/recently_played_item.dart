import 'package:flutter/material.dart';

class RecentlyPlayedItem extends StatelessWidget {
  final bool isPlaylist;
  final bool isUserAvatar;
  final String imageUrl;
  final String? userName;
  final VoidCallback onTap;

  const RecentlyPlayedItem({
    super.key,
    required this.isPlaylist,
    required this.isUserAvatar,
    required this.imageUrl,
    required this.onTap,
    this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: isPlaylist ? BoxShape.rectangle : BoxShape.circle,
          image: isUserAvatar ? null : DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
        ),
        child: isUserAvatar
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.network(
                    imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 4),
                Text(userName ?? '', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            )
          : Container(),
      ),
    );
  }
}
