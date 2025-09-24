import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/lab_report_model.dart';

class LabReportSubmissionController {
  final hba1cController = TextEditingController();
  final fastingSugarController = TextEditingController();
  final selectedDateNotifier = ValueNotifier<DateTime>(DateTime.now());
  final historyNotifier = ValueNotifier<List<LabReportSubmission>>([]);

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateNotifier.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      selectedDateNotifier.value = picked;
    }
  }

  Future<void> submitReport(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('You must be logged in.')));
      return;
    }

    final double? hba1c = double.tryParse(hba1cController.text);
    final int? fastingSugar = int.tryParse(fastingSugarController.text);

    if (hba1c == null || fastingSugar == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid numbers.')),
      );
      return;
    }

    // Calculate Average Blood Glucose (eAG)
    final double avgGlucose = (28.7 * hba1c) - 46.7;

    try {
      final reportData = {
        'hba1c': hba1c.toStringAsFixed(1),
        'fastingBloodSugar': fastingSugar.toString(),
        'avgBloodGlucose': avgGlucose.round().toString(),
        'reportDate': Timestamp.fromDate(selectedDateNotifier.value),
        'submittedAt': Timestamp.now(),
      };

      // Store in a subcollection to maintain history
      await FirebaseFirestore.instance
          .collection('lab_reports')
          .doc(user.uid)
          .collection('submissions')
          .add(reportData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report submitted successfully!')),
      );
      Navigator.pop(context, true); // Pop and return true to indicate success
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to submit report: $e')));
    }
  }

  Future<void> fetchSubmissionHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('lab_reports')
          .doc(user.uid)
          .collection('submissions')
          .orderBy('reportDate', descending: true)
          .limit(10) // Get the last 10 reports
          .get();

      final history = snapshot.docs
          .map((doc) => LabReportSubmission.fromFirestore(doc))
          .toList();
      historyNotifier.value = history;
    } catch (e) {
      debugPrint("Error fetching submission history: $e");
    }
  }

  void dispose() {
    hba1cController.dispose();
    fastingSugarController.dispose();
    selectedDateNotifier.dispose();
    historyNotifier.dispose();
  }
}
