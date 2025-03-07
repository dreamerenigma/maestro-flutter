import 'package:dartz/dartz.dart';
import '../../entities/like/like_entity.dart';

abstract class LikesRepository {
  Future<Either> getNewsLikes();
  Future<Either<dynamic, List<LikeEntity>>> getLikes();
  Future<Either> addOrRemoveFavoriteSongs(String songId);
  Future<bool> isFavoriteSong(String songId);
}
