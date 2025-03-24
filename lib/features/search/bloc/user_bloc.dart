import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_event.dart';
import 'user_state.dart';
import 'package:maestro/domain/entities/user/user_entity.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<LoadUserDataEvent>(_onLoadUserData);
  }

  Future<void> _onLoadUserData(
    LoadUserDataEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
        UserEntity userEntity = UserEntity.fromFirestore(doc);
        emit(UserLoaded(userEntity));
      } else {
        emit(UserError("No user is logged in"));
      }
    } catch (e) {
      emit(UserError("Failed to load user data: $e"));
    }
  }
}
