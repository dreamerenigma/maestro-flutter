import 'package:cloud_firestore/cloud_firestore.dart';

class RecommendedEntity {
  final String id;
  final List<String> recommendedSongIds;

  RecommendedEntity({required this.id, required this.recommendedSongIds});

  factory RecommendedEntity.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return RecommendedEntity(
      id: doc.id,
      recommendedSongIds: List<String>.from(data['recommendedSongIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'recommendedSongIds': recommendedSongIds,
    };
  }
}
