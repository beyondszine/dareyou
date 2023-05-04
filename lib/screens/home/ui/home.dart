import 'package:dareyou/screens/login/ui/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              logout();
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            icon: const Icon(Icons.logout_outlined)
          ),
        ],
      ),
    );
  }
}

Future<void> logout() async {
  await FirebaseAuth.instance.signOut();
}
