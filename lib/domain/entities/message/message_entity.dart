import '../../../features/chats/models/message_model.dart';

class MessageEntity {
  final String toId;
  final String message;
  final bool read;
  final String fromId;
  final DateTime sent;

  MessageEntity({
    required this.toId,
    required this.message,
    required this.read,
    required this.fromId,
    required this.sent,
  });

  factory MessageEntity.fromModel(MessageModel model) {
    return MessageEntity(
      toId: model.toId,
      message: model.message,
      read: model.read,
      fromId: model.fromId,
      sent: model.sent,
    );
  }

  MessageModel toModel() {
    return MessageModel(
      toId: toId,
      message: message,
      read: read,
      fromId: fromId,
      sent: sent,
    );
  }

  String formattedSentDate() {
    return "${sent.day}-${sent.month}-${sent.year}";
  }
}
