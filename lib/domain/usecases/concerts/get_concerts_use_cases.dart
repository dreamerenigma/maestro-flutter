import 'package:dartz/dartz.dart';
import '../../../service_locator.dart';
import '../../../utils/usecase/usecase.dart';
import '../../repository/concerts/concerts_repository.dart';

class GetConcertsUseCase implements UseCase<Either, dynamic> {

  @override
  Future<Either> call({params}) async {
    return await sl<ConcertsRepository>().getConcerts();
  }
}
