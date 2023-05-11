import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dareyou/data/user_model.dart';
import 'package:dareyou/utils/firestore_utils.dart' as firebase_utils;
import 'package:flutter/cupertino.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {});
    on<HomeInitialEvent>(homeInitialEvent);
    on<HomeUserLogoutEvent>(homeUserLogoutEvent);
  }

  FutureOr<void> homeInitialEvent(HomeInitialEvent event, Emitter<HomeState> emit) async {

    emit(HomeLoadingState());

    try{
      User? currentUser = await firebase_utils.getFirestoreUser();
      if (currentUser == null) {
        emit(HomeUserNotSignedInState());
      } else {
        emit(HomeUserSignedInState(currentUser: currentUser));
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(HomeUserNotSignedInState());
    }
  }

  FutureOr<void> homeUserLogoutEvent(HomeUserLogoutEvent event, Emitter<HomeState> emit) {
    User currentUser = event.currentUser;
    currentUser.logout();
    emit(HomeUserSignedOutState());
  }
}
