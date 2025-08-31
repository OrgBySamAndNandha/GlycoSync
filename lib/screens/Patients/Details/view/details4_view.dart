import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glycosync/screens/Patients/Details/controller/detail_controller.dart';

class PillsStep extends StatefulWidget {
  final DetailController controller;
  const PillsStep({super.key, required this.controller});

  @override
  State<PillsStep> createState() => _PillsStepState();
}

class _PillsStepState extends State<PillsStep> {
  bool? _takesPills;

  @override
  void initState() {
    super.initState();
    // Initialize with the value from the model if it exists
    _takesPills = widget.controller.model.takesPills;
  }

  void _onSelect(bool takesPills) {
    setState(() {
      _takesPills = takesPills;
      widget.controller.model.takesPills = takesPills;
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
                'Do you take pills?',
                textAlign: TextAlign.center,
                style: GoogleFonts.lora(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),
              // Yes Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _onSelect(true),
                  style: _takesPills == true
                      ? AppTheme.selectedOptionButtonStyle
                      : AppTheme.optionButtonStyle,
                  child: const Text('Yes'),
                ),
              ),
              const SizedBox(height: 12),
              // No Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _onSelect(false),
                  style: _takesPills == false
                      ? AppTheme.selectedOptionButtonStyle
                      : AppTheme.optionButtonStyle,
                  child: const Text('No'),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: ElevatedButton(
              onPressed: _takesPills != null
              // This is the last step for now, so we call saveDetails.
              // If you add more steps, change this back to navigateToNextPage().
                  ? () => widget.controller.saveDetails(context)
                  : null,
              style: AppTheme.nextButtonStyle,
              // Using a checkmark icon to signify this is the final step
              child: const Icon(Icons.check, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
