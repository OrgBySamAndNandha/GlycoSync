import 'package:flutter/material.dart';
import 'package:glycosync/screens/Patients/Details/controller/detail_controller.dart';

class InsulinTherapyStep extends StatefulWidget {
  final DetailController controller;
  const InsulinTherapyStep({super.key, required this.controller});

  @override
  State<InsulinTherapyStep> createState() => _InsulinTherapyStepState();
}

class _InsulinTherapyStepState extends State<InsulinTherapyStep> {
  String? _selectedTherapy;
  final List<String> _therapyTypes = [
    'Pen',
    'Syringe',
    'Pump',
    'Not on insulin'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'What insulin therapy are you on?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          // Vertical list of therapy types
          Column(
            children: _therapyTypes.map((therapy) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: _buildTherapyChip(context, therapy),
              );
            }).toList(),
          ),
          const Spacer(),
          FloatingActionButton(
            onPressed: () {
              if (_selectedTherapy != null) {
                widget.controller.model.insulinTherapy = _selectedTherapy!;
                widget.controller.nextPage();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Please select a therapy type.')),
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

  Widget _buildTherapyChip(BuildContext context, String therapy) {
    final bool isSelected = _selectedTherapy == therapy;
    return SizedBox(
      width: double.infinity,
      child: ChoiceChip(
        label: Text(therapy),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedTherapy = therapy;
            }
          });
        },
        labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isSelected ? Colors.white : Theme.of(context).primaryColor,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(
            width: 1.5,
            color: Theme.of(context).primaryColor,
          ),
        ),
        selectedColor: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).canvasColor,
      ),
    );
  }
}
