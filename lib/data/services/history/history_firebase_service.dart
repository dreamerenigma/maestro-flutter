import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../domain/entities/playlist/playlist_entity.dart';

abstract class HistoryFirebaseService {
  Future<void> addToListeningHistory(Map<String, dynamic> track);
  Future<List<Map<String, dynamic>>> fetchListeningHistory();
  Future<void> clearListeningHistory();
  Future<void> addToRecentlyPlayed(Map<String, dynamic> lists, String type);
  Future<List<Map<String, dynamic>>> fetchRecentlyPlayed();
}

class HistoryFirebaseServiceImpl extends HistoryFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addToListeningHistory(Map<String, dynamic> track) async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    if (userId.isEmpty) {
      log('No user is logged in');
      return;
    }

    try {
      log('Adding track to listening history: $track');

      final querySnapshot = await _firestore
        .collection('Users')
        .doc(userId)
        .collection('ListeningHistory')
        .where('title', isEqualTo: track['title'])
        .where('artist', isEqualTo: track['artist'])
        .limit(1)
        .get();

      if (querySnapshot.docs.isNotEmpty) {
        log('Track already exists in listening history');
        return;
      }

      final duration = track['duration'] is String ? parseDuration(track['duration']) : track['duration'] ?? 0;

      await _firestore.collection('Users').doc(userId).collection('ListeningHistory').add({
        'title': track['title'],
        'artist': track['artist'],
        'cover': track['cover'],
        'fileURL': track['fileURL'] ?? '',
        'timestamp': FieldValue.serverTimestamp(),
        'uploadedBy': track['uploadedBy'],
        'duration': duration,
        'listenCount': track['listenCount'],
        'likeCount': track['likeCount'],
      });

      log('Track added to listening history');
    } catch (e) {
      log('Error adding track to listening history: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchListeningHistory() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    if (userId.isEmpty) return [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('ListeningHistory')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return {
          'title': doc['title'] ?? 'Unknown Track',
          'artist': doc['artist'] ?? 'Unknown Artist',
          'cover': doc['cover'] ?? '',
          'fileURL': doc['fileURL'] ?? '',
          'timestamp': doc['timestamp'],
          'uploadedBy': doc['uploadedBy'] ?? '',
          'duration': doc['duration'] ?? 0,
          'listenCount': doc['listenCount'] ?? 0,
          'likeCount': data.containsKey('likeCount') ? data['likeCount'] : 0,
        };
      }).toList();
    } catch (e) {
      log("Error fetching listening history: $e");
      return [];
    }
  }

  @override
  Future<void> clearListeningHistory() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    if (userId.isEmpty) {
      log('No user is logged in');
      return;
    }

    try {
      log('Clearing listening history');

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('ListeningHistory')
        .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      log('Listening history cleared');
    } catch (e) {
      log('Error clearing listening history: $e');
    }
  }

  @override
  Future<void> addToRecentlyPlayed(Map<String, dynamic> lists, String type) async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    if (userId.isEmpty) {
      log('No user is logged in');
      return;
    }

    try {
      log('Adding to recently played: $lists');

      final existingDoc = await _firestore
        .collection('Users')
        .doc(userId)
        .collection('RecentlyPlayed')
        .where('name', isEqualTo: lists['name'])
        .limit(1)
        .get();

      if (existingDoc.docs.isNotEmpty) {
        log('User already in recently played');
        return;
      }

      await _firestore.collection('Users').doc(userId).collection('RecentlyPlayed').add({
        'image': lists['image'],
        'name': lists['name'],
        'followers': lists['followers'],
        'timestamp': FieldValue.serverTimestamp(),
        'type': type,
      });

      log('Item added to recently played');
    } catch (e) {
      log('Error adding to recently played: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchRecentlyPlayed() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    if (userId.isEmpty) return [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('RecentlyPlayed')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .get();

      return querySnapshot.docs.map((doc) {
        return {
          'image': doc['image'] ?? '',
          'name': doc['name'] ?? 'Unknown Name',
          'followers': doc['followers'] ?? 0,
          'timestamp': doc['timestamp'],
          'type': doc['type'] ?? 'unknown',
        };
      }).toList();
    } catch (e) {
      log("Error fetching recently played: $e");
      return [];
    }
  }
}
