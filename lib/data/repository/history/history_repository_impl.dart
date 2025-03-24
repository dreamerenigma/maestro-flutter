import 'package:maestro/domain/repository/history/history_repository.dart';
import '../../../service_locator.dart';
import '../../services/history/history_firebase_service.dart';

class HistoryRepositoryImpl extends HistoryRepository {

  @override
  Future<List<Map<String, dynamic>>> fetchListeningHistory() async {
    return await sl<HistoryFirebaseService>().fetchListeningHistory();
  }
}

