import 'package:dareyou/screens/login/ui/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:dareyou/firebase_options.dart';
import 'package:dareyou/assets/consts.dart';

void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Sentry
  await SentryFlutter.init(
    (options) {
      options.dsn = sentryDsn;
      options.tracesSampleRate = sampleRate;
    },
    appRunner: () async {
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
      runApp(const MyApp());
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: appTitle,
        initialRoute: initialRoutePage,
        routes: {'/login': (context) => const LoginScreen()},
        debugShowCheckedModeBanner: false
    );
  }
}
