import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

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

  FutureOr<void> verifyOTPClickedEvent(VerifyOTPClickedEvent event, Emitter<VerifyState> emit) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: event.verificationId,
      smsCode: event.enteredOTP.text.trim(),
    );
    try {
      UserCredential cred =
          await FirebaseAuth.instance.signInWithCredential(credential);
      debugPrint("credential recieved:");
      debugPrint(cred.toString());
      emit(VerifyOTPSucessState());
      // ignore: use_build_context_synchronously
      // Navigator.of(context).pushReplacementNamed('/home');
    } on FirebaseAuthException catch (authException) {
      emit(VerifyOTPFailureState(authException: authException));
    }
  }

  FutureOr<void> verifyResendOTPClickedEvent(VerifyResendOTPClickedEvent event, Emitter<VerifyState> emit) {
  }
}
