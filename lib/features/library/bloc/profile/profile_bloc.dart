import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_state.dart';
import '../../../../api/apis.dart';
import 'profile_event.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileLoading());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is LoadProfileData) {
      try {
        final userData = await APIs.fetchUserData();
        if (userData != null) {
          yield ProfileLoaded(userData);
        } else {
          yield ProfileError("Пользовательские данные не найдены");
        }
      } catch (e) {
        yield ProfileError("Ошибка при загрузке данных");
      }
    }
  }
}
