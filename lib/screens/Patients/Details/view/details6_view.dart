import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glycosync/screens/Patients/Details/controller/detail_controller.dart';
import 'package:glycosync/widgets/app_theme.dart';

class RangesStep extends StatefulWidget {
  final DetailController controller;
  const RangesStep({super.key, required this.controller});

  @override
  State<RangesStep> createState() => _RangesStepState();
}

class _RangesStepState extends State<RangesStep> {
  // You would typically get these default values from a configuration file or settings
  final String _veryHighRange = "250 mg/dL";
  final String _targetRange = "70 - 180 mg/dL";
  final String _veryLowRange = "54 mg/dL";

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
                    'What are your ranges?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lora(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'These ranges define how graphs and statistics will classify your values.',
                          style: GoogleFonts.lora(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        TextButton.icon(
                          onPressed: () {
                            // You can add a dialog or navigate to a screen with more info here
                          },
                          icon: const Icon(Icons.info_outline, color: Colors.blue),
                          label: Text(
                            'Learn more',
                            style: GoogleFonts.lora(
                                color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildRangeItem(Colors.orange, 'Very high', _veryHighRange),
                        const SizedBox(height: 16),
                        _buildRangeItem(Colors.green, 'Target range', _targetRange),
                        const SizedBox(height: 16),
                        _buildRangeItem(Colors.red, 'Very low', _veryLowRange,
                            isEditable: false),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0, top: 20.0),
            child: ElevatedButton(
              onPressed: () => widget.controller.saveDetails(context),
              style: AppTheme.nextButtonStyle,
              child: const Icon(Icons.check, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRangeItem(Color color, String title, String value,
      {bool isEditable = true}) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.lora(color: Colors.grey[600])),
            const SizedBox(height: 4),
            Text(value,
                style: GoogleFonts.lora(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            if (!isEditable) ...[
              const SizedBox(height: 4),
              Text(
                'Very low can’t be changed due to medical reasons.',
                style: GoogleFonts.lora(fontSize: 12, color: Colors.grey),
              )
            ]
          ],
        )
      ],
    );
  }
}
