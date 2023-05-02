import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dareyou/assets/consts.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: googleClientId,
  );

  LoginBloc() : super(LoginInitial()) {
    on<LoginInitialEvent>(loginInitialEvent);
    on<LoginOTPAuthButtonClickedEvent>(loginOTPAuthButtonClickedEvent);
    on<LoginGoogleAuthButtonClickedEvent>(loginGoogleAuthButtonClickedEvent);
  }

  FutureOr<void> loginInitialEvent(LoginInitialEvent event, Emitter<LoginState> emit) {
    emit(LoginLoadingState());
    emit(LoginLoadedState());
  }

  FutureOr<void> loginOTPAuthButtonClickedEvent(LoginOTPAuthButtonClickedEvent event, Emitter<LoginState> emit) async {
    final phone = '+91${event.phoneController.text.trim()}';
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) {
        debugPrint("verification completed!!");
        debugPrint(credential.toString());
        // gotta sign in here!!
      },
      verificationFailed: (exception) {
        debugPrint("exception occured");
        debugPrint(exception.message);
        emit(LoginOTPVerificationFailedState(verifyException: exception));
      },
      codeSent: (String verificationId, int? resendtoken) async {
        debugPrint("code sent!!");
        emit(LoginNavigateToVerifyPageActionState(
          verificationId: verificationId,
          resendtoken: resendtoken
        ));
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  FutureOr<void> loginGoogleAuthButtonClickedEvent(LoginGoogleAuthButtonClickedEvent event, Emitter<LoginState> emit) async {
    // Start the Google Sign-In flow
    final GoogleSignInAccount? googleUser =
        await googleSignIn.signIn();

    if (googleUser != null) {
      // Convert the GoogleSignInAccount to a GoogleAuthCredential
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase using the Google credential
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) {
            debugPrint(
                "Sign in with google credentials completed! Navigating to Home Screen!");
            emit(LoginNavigateToHomePageActionState());
          });
    } else {
      debugPrint(googleSignInNullError);
      emit(LoginGoogleVerificationFailedState(gAuthException: googleSignInNullError));
    }
  }
}
