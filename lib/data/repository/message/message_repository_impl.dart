import 'package:dartz/dartz.dart';
import 'package:maestro/data/services/message/message_firebase_service.dart';
import 'package:maestro/domain/repository/message/message_repository.dart';
import 'package:maestro/features/chats/models/message_model.dart';
import '../../../service_locator.dart';

class MessageRepositoryImpl extends MessageRepository {

  @override
  Future<Either<String, MessageModel>> addMessage(MessageModel message) async {
    return await sl<MessageFirebaseService>().addMessage(message);
  }
}
