import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot>> searchUsers(String keyword) async {
    final keywordLower = keyword.toLowerCase();

    QuerySnapshot snapshot = await _db.collection('Users')
      .where('name', isGreaterThanOrEqualTo: keywordLower)
      .where('name', isLessThanOrEqualTo: '$keywordLower\uf8ff')
      .get();

    return snapshot.docs;
  }

  Future<List<QueryDocumentSnapshot>> searchSongs(String keyword) async {
    final keywordLower = keyword.toLowerCase();

    QuerySnapshot snapshot = await _db.collection('Songs')
      .where('title', isGreaterThanOrEqualTo: keywordLower)
      .where('title', isLessThanOrEqualTo: '$keywordLower\uf8ff')
      .get();

    return snapshot.docs;
  }
}
