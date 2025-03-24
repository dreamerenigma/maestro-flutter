import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestro/routes/custom_page_route.dart';
import '../domain/entities/song/song_entity.dart';
import '../features/chats/models/message_model.dart';
import '../features/intro/screens/get_started_screen.dart';
import '../routes/routes.dart';

class APIs {
  /// -- Authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  /// -- Accessing cloud Firestore Database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// -- Return current user
  static User get user => auth.currentUser!;

  /// -- Redirect
  static Widget redirect(BuildContext context) {
    return FutureBuilder<void>(
      future: delayedNavigation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(context, createPageRoute(GetStartedScreen()));
          });
        }
        return Container();
      },
    );
  }

  /// -- Delay Navigation
  static Future<void> delayedNavigation() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  /// -- Fetch User Data
  static Future<Map<String, dynamic>?> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
        if (userDoc.exists) {
          return userDoc.data() as Map<String, dynamic>?;
        } else {
          return null;
        }
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }

  /// -- Logout account
  static Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign out: $e')),
      );
    }
  }

  /// -- Delete account
  static Future<void> deleteAccount(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('Users').doc(user.uid).delete();

        await user.delete();

        Get.offAllNamed(MaestroRoutes.signInOrSignUp);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete account: $e')),
      );
    }
  }

  /// -- Clear recently played
  static Future<void> clearRecentlyPlayed(BuildContext context) async {
    try {

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed clear recently played: $e')),
      );
    }
  }

  static Future<List<SongEntity>> fetchLikedTracks(String id) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return [];
      }

      final likedTracksRef = FirebaseFirestore.instance.collection('Users').doc(user.uid).collection('Favorites');
      final snapshot = await likedTracksRef.get();
      List<SongEntity> likedTracks = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();

        int durationInSeconds = 0;
        if (data['duration'] != null && data['duration'] is String) {
          final durationParts = data['duration'].split(':');
          if (durationParts.length == 2) {
            int minutes = int.tryParse(durationParts[0]) ?? 0;
            int seconds = int.tryParse(durationParts[1]) ?? 0;
            durationInSeconds = minutes * 60 + seconds;
          }
        } else {
          durationInSeconds = data['duration'] ?? 0;
        }

        likedTracks.add(SongEntity(
          songId: doc.id,
          title: data['title'] ?? 'Unknown Title',
          artist: data['artist'] ?? 'Unknown Artist',
          genre: data['genre'] ?? '',
          description: data['description'] ?? '',
          caption: data['caption'] ?? '',
          duration: durationInSeconds,
          releaseDate: data['releaseDate'] != null ? (data['releaseDate'] as Timestamp) : Timestamp.now(),
          isFavorite: data['isFavorite'] ?? true,
          listenCount: data['listenCount'] ?? 0,
          likeCount: data['likeCount'] ?? 0,
          commentsCount: data['commentsCount'] ?? 0,
          repostCount: data['repostCount'] ?? 0,
          fileURL: data['fileURL'] ?? '',
          cover: data['cover'] ?? '',
          uploadedBy: data['uploadedBy'] ?? '',
        ));
      }

      return likedTracks;
    } catch (e) {
      log("Error fetching liked tracks: $e");
      return [];
    }
  }

  static Future<String> getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();

        if (userDoc.exists) {
          String name = userDoc['name'] ?? 'Unknown User';
          return name;
        } else {
          return 'Unknown User';
        }
      } catch (e) {
        log('Error getting user name: $e');
        return 'Unknown User';
      }
    } else {
      return 'Unknown User';
    }
  }

  static Future<List<SongEntity>> fetchTracks(String songId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        log('User is not authenticated');
        return [];
      }

      String userName = await getUserName();


      final tracksRef = FirebaseFirestore.instance.collection('Songs').where('uploadedBy', isEqualTo: userName);
      final snapshot = await tracksRef.get();

      List<SongEntity> uploadedTracks = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();

        uploadedTracks.add(SongEntity(
          songId: doc.id,
          title: data['title'] ?? 'Unknown Title',
          artist: data['artist'] ?? 'Unknown Artist',
          genre: data['genre'] ?? '',
          description: data['description'] ?? '',
          caption: data['caption'] ?? '',
          duration: _parseDuration(data['duration']),
          releaseDate: data['releaseDate'] != null ? (data['releaseDate'] as Timestamp) : Timestamp.now(),
          isFavorite: data['isFavorite'] ?? false,
          listenCount: data['listenCount'] ?? 0,
          likeCount: data['likeCount'] ?? 0,
          commentsCount: data['commentsCount'] ?? 0,
          repostCount: data['repostCount'] ?? 0,
          fileURL: data['fileURL'] ?? '',
          cover: data['cover'] ?? '',
          uploadedBy: data['uploadedBy'] ?? '',
        ));
      }

      return uploadedTracks;
    } catch (e) {
      log("Error fetching uploaded tracks: $e");
      return [];
    }
  }

  static int _parseDuration(String duration) {
    try {
      final parts = duration.split(':');
      if (parts.length == 2) {
        final minutes = int.tryParse(parts[0]) ?? 0;
        final seconds = int.tryParse(parts[1]) ?? 0;
        return (minutes * 60) + seconds;
      }
    } catch (e) {
      log('Error parsing duration: $e');
    }
    return 0;
  }

  ///******************* Chat Screen Related APIs *******************

  /// -- Useful for getting conversation id
  static String getConversationId(String id) => user.uid.hashCode <= id.hashCode ? '${user.uid}_$id' : '${id}_${user.uid}';

  /// -- Update read status of message
  static Future<void> updateMessageReadStatus(MessageModel message) async {
  firestore
    .collection('Chats/${getConversationId(message.fromId)}/messages/')
    .doc(message.sent.toIso8601String())
    .update({'read': true});
  }
}
