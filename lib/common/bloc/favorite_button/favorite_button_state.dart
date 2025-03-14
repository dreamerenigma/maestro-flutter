abstract class FavoriteButtonState {}

class FavoriteButtonInitial extends FavoriteButtonState {}

class FavoriteButtonUpdated extends FavoriteButtonState {
  final bool isFavorite;
  final int likeCount;

  FavoriteButtonUpdated({required this.isFavorite, required this.likeCount});
}
