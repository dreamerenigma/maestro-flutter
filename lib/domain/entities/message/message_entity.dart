import '../../../features/chats/models/message_model.dart';

class MessageEntity {
  final String toId;
  final String message;
  final bool read;
  final String fromId;
  final DateTime sent;
  final List<String> deleted;

  MessageEntity({
    required this.toId,
    required this.message,
    required this.read,
    required this.fromId,
    required this.sent,
    required this.deleted,
  });

  factory MessageEntity.fromModel(MessageModel model) {
    return MessageEntity(
      toId: model.toId,
      message: model.message,
      read: model.read,
      fromId: model.fromId,
      sent: model.sent,
      deleted: model.deleted,
    );
  }

  MessageModel toModel() {
    return MessageModel(
      toId: toId,
      message: message,
      read: read,
      fromId: fromId,
      sent: sent,
      deleted: deleted,
    );
  }

  String formattedSentDate() {
    return "${sent.day}-${sent.month}-${sent.year}";
  }
}
