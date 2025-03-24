import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../api/apis.dart';
import '../../../../domain/entities/song/song_entity.dart';
import '../../../../utils/constants/app_colors.dart';
import '../tracks_widget.dart';

class UploadsTab extends StatefulWidget {
  final Map<String, dynamic> userData;

  const UploadsTab({super.key, required this.userData});

  @override
  State<UploadsTab> createState() => _UploadsTabState();
}

class _UploadsTabState extends State<UploadsTab> {
  Set<String> selectedTracks = {};
  bool isLoading = true;
  List<SongEntity> myTracks = [];

  @override
  void initState() {
    super.initState();
    _fetchTracks();
  }

  Future<void> _fetchTracks() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        log('User is not authenticated');
        return;
      }

      final tracks = await APIs.fetchTracks(user.uid);

      if (mounted) {
        setState(() {
          myTracks = tracks;
          isLoading = false;
        });
      }
    } catch (e) {
      log('Error fetching tracks: $e');
    }
  }

  void _toggleSelection(String trackId) {
    setState(() {
      if (selectedTracks.contains(trackId)) {
        selectedTracks.remove(trackId);
      } else {
        selectedTracks.add(trackId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
      ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)))
      : TracksWidget(tracks: myTracks, selectedTracks: selectedTracks, userData: widget.userData, onTrackToggle: _toggleSelection);
  }
}
