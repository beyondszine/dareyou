part of 'verify_bloc.dart';

@immutable
abstract class VerifyEvent {}

class VerifyInitialEvent extends VerifyEvent {}

class VerifyOTPClickedEvent extends VerifyEvent {
  final String enteredOTP;
  final String verificationId;

  VerifyOTPClickedEvent({
    required this.enteredOTP,
    required this.verificationId
  });
}

class VerifyResendOTPClickedEvent extends VerifyEvent {
  final String verificationId;
  final int? resendToken;
  final OtpTimerButtonController codeController;
  final String phoneNo;

  VerifyResendOTPClickedEvent({
    required this.verificationId,
    required this.resendToken,
    required this.codeController,
    required this.phoneNo
  });
}
