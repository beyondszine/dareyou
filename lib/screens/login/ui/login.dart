import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_button/sign_button.dart';
import 'package:dareyou/assets/consts.dart';

import 'package:dareyou/screens/verify/ui/verify_otp.dart';
import 'package:dareyou/screens/login/bloc/login_bloc.dart';
import 'package:dareyou/screens/home/ui/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginBloc loginBloc = LoginBloc();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    loginBloc.add(LoginInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc,LoginState>(
      bloc: loginBloc,
      listenWhen: (previous, current) => current is LoginActionState,
      buildWhen: (previous, current) => current is !LoginActionState,
      listener: (context, state) {
        switch (state.runtimeType) {
          case LoginOTPVerificationFailedState:
            final failedState = state as LoginOTPVerificationFailedState;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(failedState.verifyException.message ?? 'Something went wrong.')),
            );
            break;
          case LoginGoogleVerificationFailedState:
            final failedState = state as LoginGoogleVerificationFailedState;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(failedState.gAuthException.isNotEmpty ? failedState.gAuthException :'Something went wrong.')),
            );
            break;
          case LoginNavigateToVerifyPageActionState:
            print("Navigating to verification screen!!");
            final successState = state as LoginNavigateToVerifyPageActionState;
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => VerificationScreen(loginNavigateState: successState)
            ));
            break;
          case LoginNavigateToHomePageActionState:
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => const HomeScreen()
            ));
            break;
          default:
            debugPrint("Unhandled Action State!");
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case LoginLoadingState:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator()
              ),
            );
          case LoginLoadedState:
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
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              loginBloc.add(LoginOTPAuthButtonClickedEvent(
                                phoneController: _phoneController
                              ));
                            }
                          },
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
                              loginBloc.add(LoginGoogleAuthButtonClickedEvent());
                            }
                        )
                      )
                    ],
                  ),
                ),
              ),
            );
          default:
            return const SizedBox();
        }
      }
    );
  }
}
