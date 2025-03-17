import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:maestro/features/chats/models/message_model.dart';

abstract class MessageFirebaseService {
  Future<Either<String, MessageModel>> addMessage(MessageModel message);
  Stream<List<MessageModel>> getMessages(String fromId, String toId);
}

class MessageFirebaseServiceImpl extends MessageFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<String, MessageModel>> addMessage(MessageModel message) async {
    try {
      await _firestore.collection('Users').doc(message.fromId).collection('Messages').add({
        'fromId': message.fromId,
        'message': message.message,
        'read': message.read,
        'sent': Timestamp.fromDate(message.sent),
        'toId': message.toId,
      });

      return Right(message);

    } catch (e) {
      return Left('Failed to send message: $e');
    }
  }

  @override
  Stream<List<MessageModel>> getMessages(String fromId, String toId) {
    return _firestore
      .collection('Users')
      .doc(fromId)
      .collection('Messages')
      .where('toId', isEqualTo: toId)
      .orderBy('sent', descending: false)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return MessageModel(
            fromId: data['fromId'],
            toId: data['toId'],
            message: data['message'],
            read: data['read'] is bool ? data['read'] : data['read'] == 'true',
            sent: data['sent'] is Timestamp ? (data['sent'] as Timestamp).toDate() : DateTime.parse(data['sent']),
            deleted: List<String>.from(data['deleted'] ?? []),
          );
        }).toList();
      });
  }
}
