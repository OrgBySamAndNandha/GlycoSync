import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/profile_model.dart';
import '../model/glucose_record.dart';

class ProfileController {
  final ValueNotifier<ProfileModel?> profileNotifier = ValueNotifier(null);
  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier(true);
  final ValueNotifier<String?> errorNotifier = ValueNotifier(null);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loadProfileData() async {
    isLoadingNotifier.value = true;
    errorNotifier.value = null;

    try {
      final user = _auth.currentUser;
      if (user == null) {
        errorNotifier.value = 'Please log in to view your profile';
        isLoadingNotifier.value = false;
        return;
      }

      // First try getting data from users collection
      var userDoc = await _firestore.collection('users').doc(user.uid).get();

      // If not found in users, try patients collection
      if (!userDoc.exists) {
        userDoc = await _firestore.collection('patients').doc(user.uid).get();
        if (!userDoc.exists) {
          errorNotifier.value = 'Profile data not found';
          isLoadingNotifier.value = false;
          return;
        }
      }

      final userData = userDoc.data() ?? {};

      // Get additional details from patients_details collection
      final detailsDoc = await _firestore
          .collection('patients_details')
          .doc(user.uid)
          .get();

      final detailsData = detailsDoc.data() ?? {};

      // Combine data from both documents
      // Get name from patients_details first, then fall back to other sources
      userData['name'] = detailsData['name'] ?? userData['name'] ?? 'User';
      userData['email'] = user.email ?? userData['email'] ?? '';
      userData['gender'] =
          detailsData['gender'] ?? userData['gender'] ?? 'Not specified';
      userData['height'] = detailsData['height'] ?? userData['height'] ?? '0';
      userData['weight'] = detailsData['weight'] ?? userData['weight'] ?? '0';

      // Fetch glucose history
      final glucoseRecords = await _firestore
          .collection('patients')
          .doc(user.uid)
          .collection('routine_completions')
          .orderBy('completedAt', descending: true)
          .get();

      // Convert Firestore documents to GlucoseRecord objects
      List<Map<String, dynamic>> rawRecords = glucoseRecords.docs.map((doc) {
        final data = doc.data();
        return {
          'date':
              ((data['completedAt'] as Timestamp?)?.toDate() ?? DateTime.now())
                  .toIso8601String(),
          'glucoseImpact': (data['glucoseImpact'] as num?)?.toDouble() ?? 0.0,
          'activityType': data['levelTitle'] as String? ?? 'Activity',
        };
      }).toList();

      // Create GlucoseRecord objects using fromJson factory
      final List<GlucoseRecord> glucoseHistory = rawRecords
          .map((json) => GlucoseRecord.fromJson(json))
          .toList();

      // Calculate derived values
      double initialGlucoseLevel =
          (userData['initialGlucoseLevel'] as num?)?.toDouble() ?? 100.0;

      // Calculate total glucose impact from history
      double totalGlucoseImpact = glucoseHistory.fold(
        0.0,
        (sum, record) => sum + record.glucoseImpact,
      );

      // Calculate current predicted glucose
      double currentPredictedGlucose = initialGlucoseLevel + totalGlucoseImpact;

      // Calculate average daily change
      double averageDailyChange = glucoseHistory.isEmpty
          ? 0.0
          : totalGlucoseImpact / glucoseHistory.length;

      // Determine glucose trend
      String glucoseTrend;
      if (glucoseHistory.isEmpty) {
        glucoseTrend = 'Stable';
      } else {
        if (averageDailyChange > 1.0) {
          glucoseTrend = 'Increasing';
        } else if (averageDailyChange < -1.0) {
          glucoseTrend = 'Decreasing';
        } else {
          glucoseTrend = 'Stable';
        }
      }

      // Update the profile model with verified data
      profileNotifier.value = ProfileModel(
        name: userData['name'],
        email: userData['email'],
        age: (userData['age'] as num?)?.toInt() ?? 0,
        weight: double.tryParse(userData['weight'].toString()) ?? 0.0,
        height: double.tryParse(userData['height'].toString()) ?? 0.0,
        gender: userData['gender'],
        initialGlucoseLevel: initialGlucoseLevel,
        currentPredictedGlucose: currentPredictedGlucose,
        glucoseTrend: glucoseTrend,
        averageDailyChange: averageDailyChange,
        glucoseHistory: glucoseHistory,
      );
    } catch (e) {
      debugPrint('Error loading profile: $e');
      errorNotifier.value = 'Failed to load profile data: ${e.toString()}';
    } finally {
      isLoadingNotifier.value = false;
    }
  }

  void dispose() {
    profileNotifier.dispose();
    isLoadingNotifier.dispose();
    errorNotifier.dispose();
  }
}
