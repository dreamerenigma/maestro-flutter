import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../library/screens/library/playlist_screen.dart';
import '../../../library/screens/profile/all_playlist_screen.dart';

class PlayList extends StatefulWidget {
  final int initialIndex;
  final List<Map<String, dynamic>> playlists;

  const PlayList({super.key, required this.initialIndex, required this.playlists});

  @override
  State<PlayList> createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  List<Map<String, dynamic>> playlists = [];

  @override
  void initState() {
    super.initState();
    _loadPlaylists();
  }

  Future<void> _loadPlaylists() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('Playlists').get();
      var playlistsData = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'title': doc['title'],
          'isPublic': doc['isPublic'],
          'releaseDate': doc['releaseDate'],
          'coverImage': doc['coverImage'],
          'authorName': doc['authorName'],
        };
      }).toList();
      setState(() {
        playlists = playlistsData;
      });
    } catch (e) {
      log('Error loading playlists: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18, top: 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Playlists', style: TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.w800, letterSpacing: -1.3)),
              SizedBox(
                width: 65,
                height: 27,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      createPageRoute(AllPlaylistScreen(playlists: widget.playlists, initialIndex: widget.initialIndex)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.isDarkMode ? AppColors.darkGrey : AppColors.lightGrey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                    side: BorderSide.none,
                  ).copyWith(
                    foregroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.pressed)) {
                        return AppColors.darkerGrey;
                      } else {
                        return AppColors.white;
                      }
                    }),
                  ),
                  child: const Text('See All', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                ),
              ),
            ],
          ),
          _buildPlaylistsList(),
        ],
      ),
    );
  }

  Widget _buildPlaylistsList() {
    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: playlists.length,
        itemBuilder: (context, index) {
          final playlist = playlists[index];

          return Padding(
            padding: const EdgeInsets.only(right: 12, top: 12, bottom: 8),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  createPageRoute(PlaylistScreen(
                    initialIndex: widget.initialIndex,
                    playlists: playlists,
                  )),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  playlist['coverImage'] != null
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.darkGrey, width: 0.8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            playlist['coverImage'],
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: AppColors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.music_note, size: 40, color: Colors.white),
                      ),
                  const SizedBox(height: 4),
                  SizedBox(
                    child: Text(
                      playlist['title'] ?? 'Untitled',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, height: 1),
                    ),
                  ),
                  SizedBox(
                    child: Text(
                      playlist['authorName'] ?? 'Unknown',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13, color: AppColors.grey),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String truncateWithEllipsis(int cutoff, String text) {
    return (text.length <= cutoff) ? text : '${text.substring(0, cutoff)}...';
  }
}
