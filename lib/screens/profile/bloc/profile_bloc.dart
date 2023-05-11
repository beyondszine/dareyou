import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dareyou/models/user_profile.dart';
import 'package:dareyou/repositories/user_profile_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final UserProfileRepository userProfileRepository;

  UserProfileBloc({required UserProfileRepository userRepository})
      : userProfileRepository = userRepository,
        super(UserProfileInitial()) {
    on<UserProfileLoadStarted>(_mapUserProfileLoadStartedToState);
    on<UserProfileNameChanged>(_mapUserProfileNameChangedToState);
    // on<UserProfileImageChanged>(_mapUserProfileImageChangedToState);
    // on<UserProfileSaved>(_mapUserProfileSavedToState);
  }

  FutureOr<void> _mapUserProfileLoadStartedToState(
      UserProfileLoadStarted event, Emitter<UserProfileState> emit) async {
    debugPrint("UserProfileLoadStarted event occured!");
    emit(UserProfileLoading());
    try {
      final userProfile = await userProfileRepository.getUserProfile();
      debugPrint("userProfile: ${userProfile.toJson()}");
      emit(UserProfileLoadSuccess(userProfile: userProfile));
    } catch (error) {
      emit(UserProfileLoadFailure(error: error.toString()));
    }
  }

  FutureOr<void> _mapUserProfileNameChangedToState(
      UserProfileNameChanged event, Emitter<UserProfileState> emit) async {
    debugPrint("UserProfileNameChanged event occured!");
    //TODO: don't let it change unless it was NULL;  i.e. won't let it change after it was set

    // final currentState = state;
    // if (currentState is UserProfileLoadSuccess) {
    //   final updatedUserProfile = currentState.userProfile.copyWith(Name: event.name);
    //   emit(UserProfileLoadSuccess(userProfile: updatedUserProfile));
    // }
  }

  // FutureOr<void> _mapUserProfileAgeChangedToState(
  //     UserProfileAgeChanged event, Emitter<UserProfileState> emit) async {
  //   debugPrint("UserProfileAgeChanged event occured!");
  //   final currentState = state;
  //   if (currentState is UserProfileLoadSuccess) {
  //     final updatedUserProfile = currentState.userProfile.copyWith(age: event.age);
  //     emit(UserProfileLoadSuccess(userProfile: updatedUserProfile));
  //   }
  // }
}
