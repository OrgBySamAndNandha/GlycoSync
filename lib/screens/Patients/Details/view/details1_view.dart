import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:glycosync/screens/Patients/Details/controller/detail_controller.dart';

class PersonalInfoStep extends StatefulWidget {
  final DetailController controller;
  const PersonalInfoStep({super.key, required this.controller});

  @override
  State<PersonalInfoStep> createState() => _PersonalInfoStepState();
}

class _PersonalInfoStepState extends State<PersonalInfoStep> {
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'What is your gender?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          // Gender selection cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildGenderCard(
                context,
                'Male',
                'assets/animations/Male.json', // Placeholder for your male animation
              ),
              _buildGenderCard(
                context,
                'Female',
                'assets/animations/female.json', // Placeholder for your female animation
              ),
            ],
          ),
          const Spacer(),
          // Floating 'Next' button
          FloatingActionButton(
            onPressed: () {
              // Only proceed if a gender is selected
              if (_selectedGender != null) {
                widget.controller.updateGender(_selectedGender!);
                widget.controller.nextPage();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select a gender.')),
                );
              }
            },
            child: const Icon(Icons.arrow_forward_ios),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildGenderCard(
      BuildContext context, String gender, String lottieAsset) {
    final isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 150,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: Theme.of(context).primaryColor, width: 3)
              : Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(lottieAsset, height: 100),
            const SizedBox(height: 16),
            Text(
              gender,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
