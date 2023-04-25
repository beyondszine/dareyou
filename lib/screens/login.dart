import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
      appBar: AppBar(title: const Text('Login')),
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
                decoration: const InputDecoration(labelText: 'Phone number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _sendCode,
                child: const Text('Send code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
