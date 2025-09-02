import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glycosync/screens/Patients/auth/view/Login_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  // This function now returns a Future that resolves after fetching data
  Future<Map<String, dynamic>> _getUserData() async {
    // We add a small delay to ensure the auth state is settled
    await Future.delayed(const Duration(milliseconds: 100));

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // This will now clearly indicate if the user is not logged in
      throw Exception('User is not logged in.');
    }

    try {
      // *** FIX 1: ENSURE COLLECTION NAMES ARE CORRECT ***
      // Double-check these collection names against your Firestore database
      final patientDoc = await FirebaseFirestore.instance
          .collection('patients') // Should be plural
          .doc(user.uid)
          .get();

      final detailsDoc = await FirebaseFirestore.instance
          .collection('patients_details') // The collection for detailed info
          .doc(user.uid)
          .get();

      if (!patientDoc.exists) {
        throw Exception('Patient document does not exist.');
      }

      final Map<String, dynamic> combinedData = {
        ...patientDoc.data()!,
        ...(detailsDoc.exists ? detailsDoc.data()! : {}),
      };

      return combinedData;

    } catch (e) {
      // This will print the exact error to your console for easier debugging
      print("Error fetching user data from Firestore: $e");
      // Re-throwing the error to be caught by the FutureBuilder
      throw Exception('Failed to load profile data from Firestore.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        // The back button is removed since this is a main tab
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // *** FIX 2: IMPROVED ERROR HANDLING ***
          // This will now show the specific error message from the exception
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Could not load profile data.'));
          }

          final userData = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              _buildProfileHeader(
                name: userData['email']?.split('@').first ?? 'Patient',
                email: userData['email'] ?? 'No email found',
              ),
              const SizedBox(height: 24),
              _buildDetailsSection(userData),
              const SizedBox(height: 16),
              _buildSection([
                _buildProfileOption(Icons.delete_outline, 'Clear Cache'),
                _buildProfileOption(Icons.history, 'Clear history'),
                _buildLogoutOption(),
              ]),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  // Header with profile picture, name, email, and button
  Widget _buildProfileHeader({required String name, required String email}) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, size: 50, color: Colors.white),
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          ),
          child: const Text('Edit Profile'),
        ),
      ],
    );
  }

  // Widget to display the fetched patient details
  Widget _buildDetailsSection(Map<String, dynamic> userData) {
    return _buildSection([
      _buildDetailRow('Gender', userData['gender']),
      _buildDetailRow('Height', userData['height']),
      _buildDetailRow('Weight', userData['weight']),
      _buildDetailRow('Diabetes Type', userData['diabetesType']),
      _buildDetailRow('Takes Pills', userData['takesPills']?.toString()),
      _buildDetailRow('Insulin Therapy', userData['insulinTherapy']),
      _buildDetailRow('Glucose Unit', userData['glucoseUnit']),
      _buildDetailRow('Carbs Unit', userData['carbsUnit']),
      _buildDetailRow('Health Goals', (userData['healthGoals'] as List?)?.join(', ')),
    ]);
  }

  // Helper to build a single row in the details section
  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.black54)),
          Flexible(
            child: Text(
              value ?? 'Not set',
              textAlign: TextAlign.right,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // Generic option row with icon, text, and arrow
  Widget _buildProfileOption(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[800]),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }

  // Special logout option with red icon
  Widget _buildLogoutOption() {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text('Log Out', style: TextStyle(fontSize: 16, color: Colors.red)),
      onTap: () async {
        await FirebaseAuth.instance.signOut();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginView()),
              (Route<dynamic> route) => false,
        );
      },
    );
  }

  // A container for a group of options
  Widget _buildSection(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}