part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginInitialEvent extends LoginEvent {}

class LoginLoadingEvent extends LoginEvent {

}

class LoginOTPAuthButtonClickedEvent extends LoginEvent {
  final TextEditingController phoneController;

  LoginOTPAuthButtonClickedEvent({
    required this.phoneController
  });
}

class LoginGoogleAuthButtonClickedEvent extends LoginEvent {
}
