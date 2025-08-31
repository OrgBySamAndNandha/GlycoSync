import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glycosync/screens/Patients/auth/model/sign_up_model.dart';

class SignUpController {
  final SignUpModel model = SignUpModel();

  Future<void> signUpWithEmailAndPassword(BuildContext context) async {
    if (model.password != model.confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match.")),
      );
      return;
    }

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: model.email,
        password: model.password,
      );

      // After creating the user, create a document in Firestore
      if (userCredential.user != null) {
        await FirebaseFirestore.instance
            .collection('patients')
            .doc(userCredential.user!.uid)
            .set({
          'email': model.email,
          'createdAt': Timestamp.now(),
          'detailsCompleted': false, // Mark details as incomplete
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign up successful! Please log in.')),
        );
        // Go back to the login screen
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'An unknown error occurred.')),
      );
    }
  }
}
