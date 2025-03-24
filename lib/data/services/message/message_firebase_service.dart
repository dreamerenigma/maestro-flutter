import 'dart:developer';
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
      String chatId = getChatId(message.fromId, message.toId);

      await _firestore.collection('Chats').doc(chatId).collection('Messages').add({
        'fromId': message.fromId,
        'message': message.message,
        'read': message.read,
        'sent': Timestamp.fromDate(message.sent),
        'toId': message.toId,
      });
      log('Message added to chat\'s messages collection');

      return Right(message);
    } catch (e) {
      return Left('Failed to send message: $e');
    }
  }

  @override
  Stream<List<MessageModel>> getMessages(String fromId, String toId) {
    String chatId = getChatId(fromId, toId);

    return _firestore
      .collection('Chats')
      .doc(chatId)
      .collection('Messages')
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

  String getChatId(String user1Id, String user2Id) {
    List<String> ids = [user1Id, user2Id]..sort();
    return '${ids[0]}_${ids[1]}';
  }
}
