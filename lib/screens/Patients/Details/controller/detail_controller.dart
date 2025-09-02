import 'package:flutter/material.dart';
import 'package:glycosync/screens/Patients/Details/model/detail_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glycosync/screens/Patients/home/view/home_view.dart';

class DetailController {
  final DetailModel model = DetailModel();
  final PageController pageController = PageController();

  void nextPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  // New function to navigate to the previous page
  void previousPage() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void updateGender(String gender) {
    model.gender = gender;
  }

  void updateTakesPills(bool takesPills) {
    model.takesPills = takesPills;
  }

  Future<void> saveDetails(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: No user is logged in.')),
      );
      return;
    }

    try {
      final detailsDocRef = FirebaseFirestore.instance
          .collection('patients_details')
          .doc(user.uid);

      await detailsDocRef.set(model.toMap());

      final patientDocRef =
      FirebaseFirestore.instance.collection('patients').doc(user.uid);

      await patientDocRef.update({
        'detailsCompleted': true,
        'uid': user.uid,
      });

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeView()),
            (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save profile: $e')),
      );
    }
  }
}

