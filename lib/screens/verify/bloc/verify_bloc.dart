import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
// import 'package:meta/meta.dart';
import 'package:otp_timer_button/otp_timer_button.dart';

part 'verify_event.dart';
part 'verify_state.dart';

class VerifyBloc extends Bloc<VerifyEvent, VerifyState> {
  VerifyBloc() : super(VerifyInitial()) {
    on<VerifyInitialEvent>(verifyInitialEvent);
    on<VerifyOTPClickedEvent>(verifyOTPClickedEvent);
    on<VerifyResendOTPClickedEvent>(verifyResendOTPClickedEvent);
  }

  FutureOr<void> verifyInitialEvent(VerifyInitialEvent event, Emitter<VerifyState> emit) {
    emit(VerifyScreenLoadedState());
  }

  FutureOr<void> verifyOTPClickedEvent(
      VerifyOTPClickedEvent event, Emitter<VerifyState> emit) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: event.verificationId,
      smsCode: event.enteredOTP,
    );
    try {
      UserCredential cred = await FirebaseAuth.instance.signInWithCredential(credential);
      debugPrint("credential recieved:");
      debugPrint(cred.toString());
      emit(VerifyOTPSucessState());
      // ignore: use_build_context_synchronously
      // Navigator.of(context).pushReplacementNamed('/home');
    } on FirebaseAuthException catch (authException) {
      emit(VerifyOTPFailureState(authException: authException));
    }
  }

  FutureOr<void> verifyResendOTPClickedEvent(
      VerifyResendOTPClickedEvent event, Emitter<VerifyState> emit) async {
    event.codeController.loading();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: event.phoneNo,
      forceResendingToken: event.resendToken,
      verificationCompleted: (PhoneAuthCredential credential) {
        debugPrint("verification completed!!");
        debugPrint(credential.toString());
      },
      verificationFailed: (exception) {
        debugPrint("exception occured");
        debugPrint(exception.message);
        emit(VerifyResendOTPFailedState(authException: exception));
      },
      codeSent: (String verificationId, int? resendtoken) async {
        debugPrint("code sent!!");
        emit(VerifyScreenLoadedState());
      },
      codeAutoRetrievalTimeout: (_) {},
    );
    event.codeController.startTimer();
  }
}
