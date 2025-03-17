import 'package:dartz/dartz.dart';
import 'package:maestro/features/chats/models/message_model.dart';

abstract class MessageRepository {
  Future<Either<String, MessageModel>> addMessage(MessageModel message);
}
