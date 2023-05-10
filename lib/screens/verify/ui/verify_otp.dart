import 'package:dareyou/screens/login/bloc/login_bloc.dart';
import 'package:dareyou/screens/verify/bloc/verify_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dareyou/screens/home/ui/home.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:dareyou/assets/consts.dart';

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
        buildWhen: (previous, current) => current is! VerifyActionState,
        listener: (context, state) {
          switch (state.runtimeType) {
            case VerifyOTPFailureState:
              final failureState = state as VerifyOTPFailureState;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(failureState.authException.message ??
                        'Something went wrong.')),
              );
              break;
            case VerifyOTPSucessState:
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
              break;
            case VerifyResendOTPFailedState:
              final failureState = state as VerifyResendOTPFailedState;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(failureState.authException.message ??
                        'Something went wrong.')),
              );
          }
        },
        builder: (
          context,
          state,
        ) {
          switch (state.runtimeType) {
            case VerifyScreenLoadedState:
              return Scaffold(
                appBar: AppBar(title: const Text('Verify code')),
                body: Padding(
                  // putting padding as 5% of screen width
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Enter the 6-digit code sent to you at ${widget.loginNavigateState.phoneNo}',
                            // style: Theme.of(context).textTheme.titleSmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Center(
                          child: OTPTextField(
                            length: 6,
                            width: MediaQuery.of(context).size.width,
                            spaceBetween: 10,
                            fieldStyle: FieldStyle.underline,
                            onChanged: (pin) {},
                            onCompleted: (pin) {
                              verifyBloc.add(VerifyOTPClickedEvent(
                                  enteredOTP: pin,
                                  verificationId: widget
                                      .loginNavigateState.verificationId));
                            },
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  right:
                                      MediaQuery.of(context).size.width * 0.01),
                              child: const Text(
                                notRecievedOTPText,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            OtpTimerButton(
                              controller: _otpController,
                              onPressed: () => {
                                verifyBloc.add(VerifyResendOTPClickedEvent(
                                    verificationId: widget
                                        .loginNavigateState.verificationId,
                                    resendToken:
                                        widget.loginNavigateState.resendtoken,
                                    phoneNo: widget.loginNavigateState.phoneNo,
                                    codeController: _otpController))
                              },
                              text: const Text(otpResendButtonText),
                              duration: otpResendDuration,
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
                body: Center(child: CircularProgressIndicator()),
              );
          }
        });
  }
}
