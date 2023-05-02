import 'package:dareyou/screens/login/bloc/login_bloc.dart';
import 'package:dareyou/screens/verify/bloc/verify_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home.dart';

class VerificationScreen extends StatefulWidget {
  final LoginNavigateToVerifyPageActionState loginNavigateState;

  const VerificationScreen({Key? key, required this.loginNavigateState})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final VerifyBloc verifyBloc = VerifyBloc();
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    verifyBloc.add(VerifyInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerifyBloc, VerifyState>(
      bloc: verifyBloc,
      listenWhen: (previous, current) => current is VerifyActionState,
      buildWhen: (previous, current) => current is !VerifyActionState,
      listener: (context, state) {
        switch (state.runtimeType) {
          case VerifyOTPFailureState:
            final failureState = state as VerifyOTPFailureState;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(failureState.authException.message ?? 'Something went wrong.')),
            );
            break;
          case VerifyOTPSucessState:
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => const HomeScreen()
            ));
            break;
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case VerifyScreenLoadedState:
            return Scaffold(
              appBar: AppBar(title: const Text('Verify code')),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'OTP code'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the OTP code.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if(_formKey.currentState!.validate()) {
                              verifyBloc.add(VerifyOTPClickedEvent(
                                enteredOTP: _codeController,
                                verificationId: widget.loginNavigateState.verificationId));
                            }
                          },
                          child: const Text('Verify'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          default:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator()
              ),
            );
        }
      }
    );
  }
}
