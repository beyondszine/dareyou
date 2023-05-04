part of 'login_bloc.dart';

@immutable
abstract class LoginState {}
@immutable
abstract class LoginActionState extends LoginState{}

class LoginInitial extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginLoadedState extends LoginState {}

class LoginOTPVerificationFailedState extends LoginActionState {
  final FirebaseAuthException verifyException;

  LoginOTPVerificationFailedState({
    required this.verifyException
  });

}

class LoginNavigateToVerifyPageActionState extends LoginActionState {
  final String verificationId;
  final int? resendtoken;

  LoginNavigateToVerifyPageActionState({
    required this.verificationId,
    required this.resendtoken
  });

}

class LoginGoogleVerificationFailedState extends LoginActionState {
  final String gAuthException;

  LoginGoogleVerificationFailedState({
    required this.gAuthException
  });

}

class LoginNavigateToHomePageActionState extends LoginActionState {}
