import 'package:flutter/material.dart';
import 'package:glycosync/screens/Patients/Details/controller/detail_controller.dart';

class DiabetesTypeStep extends StatefulWidget {
  final DetailController controller;
  const DiabetesTypeStep({super.key, required this.controller});

  @override
  State<DiabetesTypeStep> createState() => _DiabetesTypeStepState();
}

class _DiabetesTypeStepState extends State<DiabetesTypeStep> {
  String? _selectedType;
  final List<String> _diabetesTypes = [
    'Type 1',
    'Type 2',
    'LADA',
    'MODY',
    'Gestational',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'What is your diabetes type?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          // Wraps the choice chips
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 12.0,
                runSpacing: 12.0,
                alignment: WrapAlignment.center,
                children: _diabetesTypes.map((type) {
                  return ChoiceChip(
                    label: Text(type),
                    selected: _selectedType == type,
                    onSelected: (isSelected) {
                      setState(() {
                        _selectedType = isSelected ? type : null;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          // 'Next' button
          FloatingActionButton(
            onPressed: () {
              if (_selectedType != null) {
                widget.controller.model.diabetesType = _selectedType!;
                // Since this is the last step for now, we'll call saveDetails.
                // In a full flow, you'd call controller.nextPage().
                widget.controller.saveDetails(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select a diabetes type.')),
                );
              }
            },
            child: const Icon(Icons.check), // Use a checkmark for the final step
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

