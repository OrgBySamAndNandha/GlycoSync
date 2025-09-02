import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glycosync/screens/Patients/Details/view/details_main_view.dart';
import 'package:glycosync/screens/Patients/Patients_bottom_navbar/patients_navbar.dart'; // Import the new NavBar
import 'package:glycosync/screens/Patients/auth/model/Login_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController {
  final LoginModel model = LoginModel();

  // Helper function to check details and navigate
  Future<void> _navigateOnLogin(User user, BuildContext context) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('patients')
          .doc(user.uid)
          .get();

      // Check if the document exists and if 'detailsCompleted' is true
      if (doc.exists && doc.data()?['detailsCompleted'] == true) {
        // *** THIS IS THE IMPROVEMENT ***
        // Navigate to the PatientsNavBar instead of the old HomeView
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PatientsNavBar()),
        );
      } else {
        // Navigate to details screen if doc doesn't exist or details are not complete
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DetailsMainView()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking user details: $e')),
      );
    }
  }

  Future<void> signInWithEmailAndPassword(BuildContext context) async {
    try {
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: model.email,
        password: model.password,
      );
      if (userCredential.user != null) {
        await _navigateOnLogin(userCredential.user!, context);
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'An unknown error occurred.')),
      );
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // The user canceled the sign-in

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        // For Google Sign-In, create user doc if it's their first time
        final userDocRef = FirebaseFirestore.instance
            .collection('patients')
            .doc(userCredential.user!.uid);
        final doc = await userDocRef.get();
        if (!doc.exists) {
          await userDocRef.set({
            'email': userCredential.user!.email,
            'createdAt': Timestamp.now(),
            'detailsCompleted': false,
          });
        }
        await _navigateOnLogin(userCredential.user!, context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed: $e')),
      );
    }
  }
}