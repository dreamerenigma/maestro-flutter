import 'package:dartz/dartz.dart';
import 'package:maestro/features/chats/models/message_model.dart';
import '../../../service_locator.dart';
import '../../../utils/usecase/usecase.dart';
import '../../repository/message/message_repository.dart';

class AddMessageUseCases implements UseCase<Either<String, MessageModel>, MessageModel> {

  @override
  Future<Either<String, MessageModel>> call({MessageModel? params}) async {
    if (params == null) {
      return Left("User ID cannot be null");
    }
    return await sl<MessageRepository>().addMessage(params);
  }
}
