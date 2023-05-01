import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_button/sign_button.dart';
import 'package:dareyou/assets/consts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: googleClientId,
  );

  Future<void> _sendCode() async {
    if (_formKey.currentState!.validate()) {
      final phone = '+91${_phoneController.text.trim()}';
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(exception.message ?? 'Something went wrong.')),
          );
        },
        codeSent: (String verificationId, int? resendtoken) async {
          debugPrint("code sent!!");
          Navigator.of(context).pushNamed('/verify', arguments: verificationId);
        },
        codeAutoRetrievalTimeout: (_) {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(loginText)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration:
                    const InputDecoration(labelText: labelForPhoneNumber),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return errorForPhoneNumber;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _sendCode,
                  child: const Text(otpSendButtonText),
                ),
              ),
              Divider(
                height: 50,
                color: Colors.grey[300],
                thickness: 1,
                indent: 50,
                endIndent: 50,
              ),
              Center(
                child: SignInButton(
                    buttonType: ButtonType.google,
                    onPressed: () async {
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
                        FirebaseAuth.instance
                            .signInWithCredential(credential)
                            .then((value) {
                          debugPrint(
                              "Sign in with google credentials completed! Navigating to Home Screen!");
                          Navigator.pushNamed(context, '/home');
                        });
                      } else {
                        debugPrint(googleSignInNullError);
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
