import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dareyou/repositories/user_repo.dart';
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
    UserRepository userRepo = UserRepository();
    try {
      await userRepo.initialize();
      emit(HomeUserSignedInState(userRepo: userRepo));
    } catch(e) {
      debugPrint(e.toString());
      emit(HomeUserNotSignedInState());
    }
  }

  FutureOr<void> homeUserLogoutEvent(HomeUserLogoutEvent event, Emitter<HomeState> emit) {
    UserRepository userRepo = event.userRepo;
    userRepo.logout();
    emit(HomeUserSignedOutState());
  }
}
