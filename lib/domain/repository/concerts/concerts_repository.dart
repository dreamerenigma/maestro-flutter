import 'package:dartz/dartz.dart';

abstract class ConcertsRepository {
  Future<Either> getConcerts();
}
