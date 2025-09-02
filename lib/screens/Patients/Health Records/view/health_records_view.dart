import 'package:flutter/material.dart';

class HealthRecordsView extends StatelessWidget {
  const HealthRecordsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            // We keep CrossAxisAlignment.start to align other potential widgets to the left
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // *** THIS IS THE FIX ***
              // Wrap the Text widget with a Center widget to center it horizontally.
              Center(
                child: Text(
                  'Health records', // Capitalized for consistency
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 24), // Add some space below the title
              // You can add the rest of your profile screen content below
              Expanded(
                child: Center(
                  child: Text(
                    '',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}