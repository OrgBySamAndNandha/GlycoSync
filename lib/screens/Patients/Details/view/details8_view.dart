import 'package:flutter/material.dart';

import 'package.flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glycosync/screens/Patients/Details/controller/detail_controller.dart';
import 'package:glycosync/widgets/app_theme.dart';

class GoalsStep extends StatefulWidget {
  final DetailController controller;
  const GoalsStep({super.key, required this.controller});

  @override
  State<GoalsStep> createState() => _GoalsStepState();
}

class _GoalsStepState extends State<GoalsStep> {
  String? _selectedGoal;
  final List<Map<String, dynamic>> _goals = [
    {'icon': Icons.monitor_weight_outlined, 'text': 'Weight loss'},
    {'icon': Icons.restaurant_menu_outlined, 'text': 'Mindful Eating/Intuitive eating'},
    {'icon': Icons.healing_outlined, 'text': 'Gut Health'},
    {'icon': Icons.bloodtype_outlined, 'text': 'Insulin Resistance'},
    {'icon': Icons.female_outlined, 'text': "Women's Health (PCOS, Fertility)"},
    {'icon': Icons.medical_services_outlined, 'text': 'Manage Pre Diabetes/Diabetes'},
  ];

  void _onSelect(String goal) {
    setState(() {
      _selectedGoal = goal;
      // You would save this to your model, e.g., widget.controller.model.primaryGoal = goal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'What can we help you with?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lora(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Column(
                    children: _goals.map((goal) {
                      final isSelected = _selectedGoal == goal['text'];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: OutlinedButton.icon(
                          onPressed: () => _onSelect(goal['text']),
                          icon: Icon(goal['icon']),
                          label: Text(goal['text']),
                          style: isSelected
                              ? AppTheme.selectedOptionButtonStyle
                              : AppTheme.optionButtonStyle,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0, top: 20.0),
            child: ElevatedButton(
              onPressed: (_selectedGoal != null && _selectedGoal!.isNotEmpty)
                  ? () => widget.controller.saveDetails(context)
                  : null,
              style: AppTheme.nextButtonStyle,
              child: const Icon(Icons.check, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
