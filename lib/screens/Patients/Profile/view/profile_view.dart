import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glycosync/screens/Patients/auth/view/Login_view.dart';
// Import the new details view
import 'package:glycosync/screens/Patients/Profile/view/my_details_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  Future<DocumentSnapshot> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User is not logged in.');
    }
    return FirebaseFirestore.instance.collection('patients').doc(user.uid).get();
  }

  @override
  Widget build(BuildContext context) {
    // The Scaffold will now automatically use the backgroundColor from your app_theme.dart
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        // The AppBar will also use the theme's scaffoldBackgroundColor
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,


      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Could not load profile.'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              _buildProfileHeader(
                name: userData['email']?.split('@').first ?? 'Patient',
                email: userData['email'] ?? 'No email found',
              ),
              const SizedBox(height: 32),
              // This is the new "My Details" button section
              _buildSection([
                _buildProfileOption(
                  context, // Pass context for navigation
                  Icons.person_outline,
                  'My Details',
                ),
                // You can add more options here if needed
              ]),
              const SizedBox(height: 16),
              _buildSection([
                _buildProfileOption(context, Icons.delete_outline, 'Clear Cache'),
                _buildProfileOption(context, Icons.history, 'Clear history'),
                _buildLogoutOption(),
              ]),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

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
            backgroundColor: Colors.green, // As per your image
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

  // Updated to handle navigation
  Widget _buildProfileOption(BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[800]),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Navigation logic for the "My Details" button
        if (title == 'My Details') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyDetailsView()),
          );
        }
        // Add other onTap logic here for other buttons if needed
      },
    );
  }

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

  Widget _buildSection(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // White background for the list tile sections
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}