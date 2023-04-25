import 'package:dareyou/screens/login.dart';
import 'package:dareyou/screens/verify_otp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTP Authentication Demo',
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/verify': (context) => VerificationScreen(
              verificationId:
                  ModalRoute.of(context)!.settings.arguments as String,
            ),
        '/home': (context) => const Text("Home Screen!!"),
      },
    );
  }
}

class HomeScreen {}
