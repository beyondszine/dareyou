part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

@immutable
abstract class HomeActionState extends HomeState {}


class HomeInitial extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeUserSignedInState extends HomeState {
  final User currentUser;

  HomeUserSignedInState({required this.currentUser});
}

class HomeUserNotSignedInState extends HomeActionState {}
class HomeUserSignedOutState extends HomeActionState {}


