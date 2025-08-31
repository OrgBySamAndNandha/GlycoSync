import 'package:flutter/material.dart';

import 'package.flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glycosync/screens/Patients/Details/controller/detail_controller.dart';
import 'package:glycosync/widgets/app_theme.dart';

class InsulinTherapyStep extends StatefulWidget {
  final DetailController controller;
  const InsulinTherapyStep({super.key, required this.controller});

  @override
  State<InsulinTherapyStep> createState() => _InsulinTherapyStepState();
}

class _InsulinTherapyStepState extends State<InsulinTherapyStep> {
  String? _selectedTherapy;
  final List<String> _therapyTypes = [
    'Pen / Syringes',
    'Pump',
    'No insulin',
  ];

  @override
  void initState() {
    super.initState();
    _selectedTherapy = widget.controller.model.insulinTherapy;
  }

  void _onSelect(String therapy) {
    setState(() {
      _selectedTherapy = therapy;
      widget.controller.model.insulinTherapy = therapy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                'What is your insulin therapy?',
                textAlign: TextAlign.center,
                style: GoogleFonts.lora(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),
              Column(
                children: _therapyTypes.map((therapy) {
                  final isSelected = _selectedTherapy == therapy;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _onSelect(therapy),
                        style: isSelected
                            ? AppTheme.selectedOptionButtonStyle
                            : AppTheme.optionButtonStyle,
                        child: Text(therapy),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: ElevatedButton(
              onPressed: (_selectedTherapy != null && _selectedTherapy!.isNotEmpty)
                  ? () => widget.controller.navigateToNextPage()
                  : null,
              style: AppTheme.nextButtonStyle,
              child: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
