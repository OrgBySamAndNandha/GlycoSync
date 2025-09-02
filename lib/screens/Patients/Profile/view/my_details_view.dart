import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDetailsView extends StatelessWidget {
  const MyDetailsView({super.key});

  Future<Map<String, dynamic>> _getUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in.');
    }

    final detailsDoc = await FirebaseFirestore.instance
        .collection('patients_details')
        .doc(user.uid)
        .get();

    if (!detailsDoc.exists) {
      throw Exception('Details not found for this user.');
    }
    return detailsDoc.data()!;
  }

  @override
  Widget build(BuildContext context) {
    // This screen will use the default scaffold background color from your theme
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Details', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white, // White AppBar background
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black), // Back arrow color
      ),
      backgroundColor: Colors.white, // White page background
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No details found.'));
          }

          final details = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                _buildDetailRow('Gender', details['gender']),
                _buildDetailRow('Height', details['height']),
                _buildDetailRow('Weight', details['weight']),
                _buildDetailRow('Diabetes Type', details['diabetesType']),
                _buildDetailRow('Takes Pills', details['takesPills']?.toString()),
                _buildDetailRow('Insulin Therapy', details['insulinTherapy']),
                _buildDetailRow('Glucose Unit', details['glucoseUnit']),
                _buildDetailRow('Carbs Unit', details['carbsUnit']),
                _buildDetailRow('Health Goals', (details['healthGoals'] as List?)?.join(', ')),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          Flexible(
            child: Text(
              value ?? 'N/A',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}