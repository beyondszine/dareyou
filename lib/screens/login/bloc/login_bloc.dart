import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dareyou/assets/consts.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  LoginBloc() : super(LoginInitial()) {
    on<LoginInitialEvent>(loginInitialEvent);
    on<LoginOTPAuthButtonClickedEvent>(loginOTPAuthButtonClickedEvent);
    on<LoginGoogleAuthButtonClickedEvent>(loginGoogleAuthButtonClickedEvent);
  }

  FutureOr<void> loginInitialEvent(
      LoginInitialEvent event, Emitter<LoginState> emit) {
    emit(LoginLoadingState());
    emit(LoginLoadedState());
  }

  FutureOr<void> loginOTPAuthButtonClickedEvent(
      LoginOTPAuthButtonClickedEvent event, Emitter<LoginState> emit) async {
    // doing this to trigger loader
    emit(LoginLoadingState());

    final phone = '+91${event.phoneController.text.trim()}';

    // TODO: get to fix this jugaad & either understand why this is happening or find a better way to do this
    // one idea that I curretnly have in mind is to - not emit but add events & they can be handled elsewhere.
    final completer = Completer<bool>();

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        debugPrint("verification completed!!");
        debugPrint(credential.toString());
        // gotta sign in here!!
      },
      verificationFailed: (exception) {
        debugPrint("exception occured");
        debugPrint(exception.message);
        emit(LoginOTPVerificationFailedState(verifyException: exception));
        completer.complete(false);
      },
      codeSent: (String verificationId, int? resendtoken) {
        debugPrint("code sent!!");
        emit(LoginNavigateToVerifyPageActionState(
            verificationId: verificationId,
            resendtoken: resendtoken,
            phoneNo: phone));
        completer.complete(true);
      },
      codeAutoRetrievalTimeout: (_) {},
    );

    await completer.future;
  }

  FutureOr<void> loginGoogleAuthButtonClickedEvent(
      LoginGoogleAuthButtonClickedEvent event, Emitter<LoginState> emit) async {
    // show the loader
    emit(LoginLoadingState());

    // Start the Google Sign-In flow
    final GoogleSignInAccount? googleUser;
    try {
      googleUser = await googleSignIn.signIn();
    } catch (e) {
      debugPrint("google signin error: ");
      debugPrint(e.toString());
      return emit(
          LoginGoogleVerificationFailedState(gAuthException: e.toString()));
    }

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
      emit(LoginGoogleVerificationFailedState(
          gAuthException: googleSignInNullError));
    }
  }
}
