import 'package:dartz/dartz.dart';
import 'package:maestro/domain/repository/repost/repost_repository.dart';
import '../../../data/models/repost/repost_model.dart';
import '../../../service_locator.dart';
import '../../../utils/usecase/usecase.dart';
import '../../params/repost/repost_params.dart';

class AddRepostUseCases implements UseCase<Either<String, RepostModel>, AddRepostParams> {

  @override
  Future<Either<String, RepostModel>> call({AddRepostParams? params}) async {
    return await sl<RepostRepository>().addRepost(params!.userId, params.targetId, params.targetType);
  }
}
