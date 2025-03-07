import 'package:dartz/dartz.dart';

abstract class VideosRepository {

  Future<Either> getVideos();
}
