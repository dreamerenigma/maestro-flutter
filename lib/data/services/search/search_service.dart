import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot>> searchByKeyword(String keyword) async {
    final keywordLower = keyword;

    QuerySnapshot usersSnapshot = await _db.collection('Users')
      .where('name', isGreaterThanOrEqualTo: keywordLower)
      .where('name', isLessThanOrEqualTo: '$keywordLower\uf8ff')
      .get();

    QuerySnapshot songsSnapshot = await _db.collection('Songs')
      .where('title', isGreaterThanOrEqualTo: keywordLower)
      .where('title', isLessThanOrEqualTo: '$keywordLower\uf8ff')
      .get();

    log('Users found: ${usersSnapshot.docs.length}');
    log('Songs found: ${songsSnapshot.docs.length}');

    return [...usersSnapshot.docs, ...songsSnapshot.docs];
  }
}
