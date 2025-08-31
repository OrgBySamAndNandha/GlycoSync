// lib/app/auth/login/controllers/login_controller.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:glycosync/screens/Patients/auth/model/Login_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class LoginController {
  final LoginModel model = LoginModel();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Function to handle email and password login
  Future<UserCredential?> signInWithEmailAndPassword(BuildContext context) async {
    try {
      if (model.email.isEmpty || model.password.isEmpty) {
        _showErrorDialog(context, "Please enter both email and password.");
        return null;
      }
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: model.email,
        password: model.password,
      );
      // You can navigate to a home screen here upon successful login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Successful!")),
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else {
        errorMessage = 'An unknown error occurred.';
      }
      _showErrorDialog(context, errorMessage);
      return null;
    }
  }

  // Function to handle Google Sign-In
  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Google Sign-In Successful!")),
      );
      // You can navigate to a home screen here
      return userCredential;
    } catch (e) {
      _showErrorDialog(context, "Failed to sign in with Google. Please try again.");
      return null;
    }
  }

  // Helper to show an error dialog
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }
}
