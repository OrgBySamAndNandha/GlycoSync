import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glycosync/screens/Patients/Details/controller/detail_controller.dart';
import 'package:glycosync/widgets/app_theme.dart';

class MeterStep extends StatefulWidget {
  final DetailController controller;
  const MeterStep({super.key, required this.controller});

  @override
  State<MeterStep> createState() => _MeterStepState();
}

class _MeterStepState extends State<MeterStep> {
  String? _selectedMeter;
  final List<String> _meterTypes = [
    'Accu-Chek Guide',
    'Accu-Chek Instant',
    'Other device',
  ];

  @override
  void initState() {
    super.initState();
    _selectedMeter = widget.controller.model.glucoseMeter;
  }

  void _onSelect(String meter) {
    setState(() {
      _selectedMeter = meter;
      widget.controller.model.glucoseMeter = meter;
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
                'Which meter do you use?',
                textAlign: TextAlign.center,
                style: GoogleFonts.lora(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),
              Column(
                children: _meterTypes.map((meter) {
                  final isSelected = _selectedMeter == meter;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _onSelect(meter),
                        style: isSelected
                            ? AppTheme.selectedOptionButtonStyle
                            : AppTheme.optionButtonStyle,
                        child: Text(meter),
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
              onPressed: (_selectedMeter != null && _selectedMeter!.isNotEmpty)
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
