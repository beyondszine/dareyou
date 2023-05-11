part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

class HomeUserLogoutEvent extends HomeEvent {
  final User currentUser;

  HomeUserLogoutEvent({required this.currentUser});
}

