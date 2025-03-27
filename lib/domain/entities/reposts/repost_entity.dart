import 'package:cloud_firestore/cloud_firestore.dart';
import '../song/song_entity.dart';

class RepostEntity {
  final String repostId;
  final String userId;
  final String type;
  final String targetId;
  final DateTime createdAt;

  RepostEntity({
    required this.repostId,
    required this.userId,
    required this.type,
    required this.targetId,
    required this.createdAt,
  });

  factory RepostEntity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RepostEntity(
      repostId: data['repostId'],
      userId: data['userId'],
      type: data['type'],
      targetId: data['targetId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Future<SongEntity> getSong() async {
    final doc = await FirebaseFirestore.instance.collection('Songs').doc(targetId).get();
    if (doc.exists) {
      return SongEntity.fromFirestore(doc);
    } else {
      throw Exception('Song not found');
    }
  }
}
