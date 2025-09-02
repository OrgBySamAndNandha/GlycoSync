import 'package:flutter/material.dart';
import 'package:glycosync/screens/Patients/Details/controller/detail_controller.dart';

class PhysicalMetricsStep extends StatefulWidget {
  final DetailController controller;
  const PhysicalMetricsStep({super.key, required this.controller});

  @override
  State<PhysicalMetricsStep> createState() => _PhysicalMetricsStepState();
}

class _PhysicalMetricsStepState extends State<PhysicalMetricsStep> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'What are your measurements?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            _buildTextField(
              controller: _heightController,
              label: 'Height',
              hint: 'e.g., 175',
              suffixText: 'cm',
            ),
            const SizedBox(height: 24),
            _buildTextField(
              controller: _weightController,
              label: 'Weight',
              hint: 'e.g., 70',
              suffixText: 'kg',
            ),
            const Spacer(),
            FloatingActionButton(
              onPressed: () {
                // Validate the form before proceeding
                if (_formKey.currentState!.validate()) {
                  // Update the model with the input values
                  widget.controller.model.height = _heightController.text;
                  widget.controller.model.weight = _weightController.text;
                  // Go to the next page
                  widget.controller.nextPage();
                }
              },
              child: const Icon(Icons.arrow_forward_ios),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String suffixText,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: suffixText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
    );
  }
}
