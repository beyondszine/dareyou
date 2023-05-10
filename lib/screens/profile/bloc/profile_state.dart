part of 'profile_bloc.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object> get props => [];
}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoadSuccess extends UserProfileState {
  final UserProfile userProfile;

  const UserProfileLoadSuccess({required this.userProfile});

  @override
  List<Object> get props => [userProfile];
}

class UserProfileLoadFailure extends UserProfileState {
  final String error;

  const UserProfileLoadFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class UserProfileSaveInProgress extends UserProfileState {}

class UserProfileSaveSuccess extends UserProfileState {}

class UserProfileSaveFailure extends UserProfileState {}
