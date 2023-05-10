part of 'verify_bloc.dart';

@immutable
abstract class VerifyState {}

@immutable
abstract class VerifyActionState extends VerifyState {}

class VerifyInitial extends VerifyState {}

class VerifyScreenLoadedState extends VerifyState {}

class VerifyOTPFailureState extends VerifyActionState {
  final FirebaseAuthException authException;

  VerifyOTPFailureState({
    required this.authException
  });

}

class VerifyOTPSucessState extends VerifyActionState {}

class VerifyResendOTPFailedState extends VerifyActionState {
  final FirebaseAuthException authException;

  VerifyResendOTPFailedState({
    required this.authException
  });
}
