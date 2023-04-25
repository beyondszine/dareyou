import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerificationScreen extends StatefulWidget {
  final String verificationId;

  const VerificationScreen({Key? key, required this.verificationId})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _verifyCode() async {
    if (_formKey.currentState!.validate()) {
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _codeController.text.trim(),
      );
      try {
        UserCredential cred =
            await FirebaseAuth.instance.signInWithCredential(credential);
        debugPrint("credential recieved:");
        debugPrint(cred.toString());
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacementNamed('/home');
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Something went wrong.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              ElevatedButton(
                onPressed: _verifyCode,
                child: const Text('Verify'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> logout() async {
  await FirebaseAuth.instance.signOut();
}
