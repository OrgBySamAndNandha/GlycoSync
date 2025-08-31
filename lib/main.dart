import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// Make sure these import paths are correct for your project structure
import 'package:glycosync/screens/Patients/auth/view/Login_view.dart';
import 'package:glycosync/firebase_options.dart';
import 'package:glycosync/screens/widgets/app_theme.dart';

void main() async {
  // Ensure that Flutter widgets are initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Runs the main application widget.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GlycoSync',
      debugShowCheckedModeBanner: false,
      // Apply the global theme to the entire app
      theme: appTheme,
      home: const LoginView(),
    );
  }
}

