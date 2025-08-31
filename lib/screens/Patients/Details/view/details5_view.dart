import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glycosync/screens/Patients/Details/controller/detail_controller.dart';
import 'package:glycosync/screens/widgets/app_theme.dart';

class UnitsStep extends StatefulWidget {
  final DetailController controller;
  const UnitsStep({super.key, required this.controller});

  @override
  State<UnitsStep> createState() => _UnitsStepState();
}

class _UnitsStepState extends State<UnitsStep> {
  String? _selectedGlucoseUnit;
  String? _selectedCarbsUnit;

  final List<String> _glucoseUnits = ['mg/dL', 'mmol/L'];
  final List<String> _carbsUnits = ['g', 'ex'];

  @override
  void initState() {
    super.initState();
    _selectedGlucoseUnit = widget.controller.model.glucoseUnit;
    _selectedCarbsUnit = widget.controller.model.carbsUnit;
  }

  void _onGlucoseSelect(String unit) {
    setState(() {
      _selectedGlucoseUnit = unit;
      widget.controller.model.glucoseUnit = unit;
    });
  }

  void _onCarbsSelect(String unit) {
    setState(() {
      _selectedCarbsUnit = unit;
      widget.controller.model.carbsUnit = unit;
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
                    'What units do you use?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lora(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "If you're not sure what units are right for you, ask your healthcare professional.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lora(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildUnitSection('Glucose', _glucoseUnits, _selectedGlucoseUnit, _onGlucoseSelect),
                  const SizedBox(height: 24),
                  _buildUnitSection('Carbs', _carbsUnits, _selectedCarbsUnit, _onCarbsSelect),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0, top: 20.0),
            child: ElevatedButton(
              onPressed: (_selectedGlucoseUnit != null && _selectedCarbsUnit != null)
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

  Widget _buildUnitSection(
      String title, List<String> options, String? selectedValue, ValueChanged<String> onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.lora(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: options.map((unit) {
            final isSelected = selectedValue == unit;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: OutlinedButton(
                  onPressed: () => onSelect(unit),
                  style: isSelected
                      ? AppTheme.selectedOptionButtonStyle
                      : AppTheme.optionButtonStyle,
                  child: Text(unit),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
