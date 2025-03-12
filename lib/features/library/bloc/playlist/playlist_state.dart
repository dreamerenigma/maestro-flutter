import 'package:maestro/domain/entities/playlist/playlist_entity.dart';

abstract class PlaylistState {}

class PlaylistInitial extends PlaylistState {}

class PlaylistLoading extends PlaylistState {
  final bool isLoading;

  PlaylistLoading({this.isLoading = true});
}

class PlaylistLoaded extends PlaylistState {
  final PlaylistEntity playlist;

  PlaylistLoaded({required this.playlist});
}

class PlaylistLoadFailure extends PlaylistState {}
