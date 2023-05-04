part of 'verify_bloc.dart';

@immutable
abstract class VerifyEvent {}

class VerifyInitialEvent extends VerifyEvent {}

class VerifyOTPClickedEvent extends VerifyEvent {
  final TextEditingController enteredOTP;
  final String verificationId;

  VerifyOTPClickedEvent({
    required this.enteredOTP,
    required this.verificationId
  });
}

class VerifyResendOTPClickedEvent extends VerifyEvent {}
