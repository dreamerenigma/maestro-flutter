import 'package:dartz/dartz.dart';
import 'package:maestro/domain/repository/song/songs_repository.dart';
import '../../../service_locator.dart';
import '../../../utils/usecase/usecase.dart';

class GetPlayListUseCase implements UseCase<Either, dynamic> {

  @override
  Future<Either> call({params}) async {
    return await sl<SongsRepository>().getPlayList();
  }
}
