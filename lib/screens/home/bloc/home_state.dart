part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

@immutable
abstract class HomeActionState extends HomeState {}


class HomeInitial extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeUserSignedInState extends HomeState {
  final UserRepository userRepo;

  HomeUserSignedInState({required this.userRepo});
}

class HomeUserNotSignedInState extends HomeActionState {}
class HomeUserSignedOutState extends HomeActionState {}


