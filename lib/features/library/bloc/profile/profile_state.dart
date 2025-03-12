abstract class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Map<String, dynamic>? userData;
  ProfileLoaded(this.userData);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
