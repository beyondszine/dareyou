import 'package:dareyou/screens/login/bloc/login_bloc.dart';
import 'package:dareyou/screens/verify/bloc/verify_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dareyou/screens/home/ui/home.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

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
  final OtpTimerButtonController _otpController = OtpTimerButtonController();
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
          case VerifyResendOTPFailedState:
            final failureState = state as VerifyResendOTPFailedState;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(failureState.authException.message ?? 'Something went wrong.')),
            );
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
                      Center(
                        child: OTPTextField(
                          length: 6,
                          style: const TextStyle(
                            fontSize: 17
                          ),
                          width: MediaQuery.of(context).size.width,
                          spaceBetween: 10,
                          textFieldAlignment: MainAxisAlignment.center,
                          fieldStyle: FieldStyle.underline,
                          onChanged: (pin) {},
                          onCompleted: (pin) {
                            verifyBloc.add(VerifyOTPClickedEvent(
                                  enteredOTP: pin,
                                  verificationId: widget.loginNavigateState.verificationId
                            ));
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            "Didn't recieve OTP?",
                            style: TextStyle(
                              color: Colors.grey
                            ),
                          ),
                          OtpTimerButton(
                            controller: _otpController,
                            onPressed: () => {
                              verifyBloc.add(VerifyResendOTPClickedEvent(
                                verificationId:  widget.loginNavigateState.verificationId,
                                resendToken: widget.loginNavigateState.resendtoken,
                                phoneNo: widget.loginNavigateState.phoneNo,
                                codeController: _otpController
                              ))
                            },
                            text: const Text('Resend OTP'),
                            duration: 30,
                          ),
                        ],
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
