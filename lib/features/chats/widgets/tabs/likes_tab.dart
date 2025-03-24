import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../api/apis.dart';
import '../../../../domain/entities/song/song_entity.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../library/screens/profile/widgets/liked_tracks_widget.dart';

class LikesTab extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Function(Set<String>) onTrackSelected;

  const LikesTab({super.key, required this.userData, required this.onTrackSelected});

  @override
  State<LikesTab> createState() => _LikesTabState();
}

class _LikesTabState extends State<LikesTab> {
  List<SongEntity> likedTracks = [];
  Set<String> selectedLikedTracks = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLikedTracks();
  }

  Future<void> _fetchLikedTracks() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final List<SongEntity> tracks = await APIs.fetchLikedTracks(user.uid);
        log('Fetched liked tracks: ${tracks.map((track) => track.songId).toList()}');

        if (mounted) {
          setState(() {
            likedTracks = tracks;
            isLoading = false;
          });

          log("LikedTracks after setState: ${likedTracks.map((track) => track.songId).join(", ")}");
          widget.onTrackSelected(likedTracks.map((track) => track.songId).toSet());
          log("Liked tracks selected: ${likedTracks.map((track) => track.songId).toSet()}");
        }
      } else {
        log('User is not authenticated');
      }
    } catch (e) {
      log('Error fetching liked tracks: $e');
    }
  }

  void _toggleSelection(String likedTrackId) {
    setState(() {
      if (selectedLikedTracks.contains(likedTrackId)) {
        selectedLikedTracks.remove(likedTrackId);
      } else {
        selectedLikedTracks.add(likedTrackId);
      }
    });

    log('Selected liked tracks: $selectedLikedTracks');
    widget.onTrackSelected(selectedLikedTracks);
  }

  @override
  Widget build(BuildContext context) {
    log('LikedTracks before rendering: ${likedTracks.map((track) => track.songId).toList()}');
    return isLoading
      ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)))
      : LikedTracksWidget(likedTracks: likedTracks, selectedLikedTracks: selectedLikedTracks, userData: widget.userData, onTrackToggle: _toggleSelection);
  }
}
