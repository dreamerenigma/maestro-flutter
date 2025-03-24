import 'package:maestro/domain/repository/history/history_repository.dart';
import '../../../service_locator.dart';
import '../../../utils/usecase/usecase.dart';

class FetchListeningHistoryUseCases implements UseCase<List<Map<String, dynamic>>, dynamic> {

  @override
  Future<List<Map<String, dynamic>>> call({params}) async {
    return await sl<HistoryRepository>().fetchListeningHistory();
  }
}

