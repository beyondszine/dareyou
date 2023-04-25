import 'package:dareyou/screens/login.dart';
import 'package:dareyou/screens/verify_otp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'firebase_options.dart';

void main() async {
  // Initialize Sentry
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://657acfc9e0f04864af6a6739c00f8ede@o4505075547439104.ingest.sentry.io/4505075548946432';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(const MyApp()),
  );

  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e, stackTrace) {
    // Report the exception to Sentry
    await Sentry.captureException(
      e,
      stackTrace: stackTrace,
    );
  }
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
