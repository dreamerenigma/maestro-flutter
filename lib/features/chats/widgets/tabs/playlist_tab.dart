import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

class PlaylistTab extends StatefulWidget {
  final int initialIndex;
  final Map<String, dynamic> userData;

  const PlaylistTab({super.key, required this.initialIndex, required this.userData});

  @override
  State<PlaylistTab> createState() => PlaylistTabState();
}

class PlaylistTabState extends State<PlaylistTab> {
  late final int selectedIndex;
  List<Map<String, dynamic>> playlists = [];
  Set<String> selectedPlaylists = {};
  bool isLoading = true;
  bool playlistsLoaded = false;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    _loadPlaylists();
  }

  Future<void> _loadPlaylists() async {
    if (playlistsLoaded) return;

    try {
      var snapshot = await FirebaseFirestore.instance
        .collection('Playlists')
        .where('authorName', isEqualTo: widget.userData['name'])
        .get();

      log('Loaded ${snapshot.docs.length} playlists for current user');

      setState(() {
        playlists = snapshot.docs.map((doc) => {
          'id': doc.id,
          'title': doc['title'],
          'isPublic': doc['isPublic'],
          'releaseDate': doc['releaseDate'],
          'coverImage': doc['coverImage'],
          'authorName': doc['authorName'],
        }).toList();
        isLoading = false;
        playlistsLoaded = true;
      });
    } catch (e) {
      log('Error loading playlists: $e');
    }
  }

  void _toggleSelection(String playlistId) {
    setState(() {
      if (selectedPlaylists.contains(playlistId)) {
        selectedPlaylists.remove(playlistId);
      } else {
        selectedPlaylists.add(playlistId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
      ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)))
      : _buildPlaylistsList(widget.userData);
  }

  Widget _buildPlaylistsList(Map<String, dynamic> userData) {
    List filteredPlaylists = playlists.where((playlist) {
      return playlist['authorName'] == (userData['name'] ?? '');
    }).toList();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredPlaylists.length,
      itemBuilder: (context, index) {
        final playlist = filteredPlaylists[index];
        final bool isSelected = selectedPlaylists.contains(playlist['id']);

        return InkWell(
          onTap: () => _toggleSelection(playlist['id']),
          splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
          highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
          child: Container(
            decoration: BoxDecoration(color: isSelected ? AppColors.darkGrey.withAlpha((0.4 * 255).toInt()) : AppColors.transparent),
            child: Padding(
              padding: const EdgeInsets.only(left: 18, right: 8, top: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
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
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : const Icon(Icons.music_note, size: 50, color: AppColors.grey),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(playlist['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.fontSizeMd)),
                          Text(playlist['authorName'] ?? 'Unknown author', style: TextStyle(fontWeight: FontWeight.w400, fontSize: AppSizes.fontSizeSm, color: AppColors.grey)),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => _toggleSelection(playlist['id']),
                    icon: Icon(
                      isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
                      size: 24,
                      color: isSelected ? AppColors.grey : (context.isDarkMode ? AppColors.lightGrey : AppColors.darkerGrey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox.shrink(),
    );
  }
}
