import 'package:flutter/material.dart';
import 'package:glycosync/screens/Patients/Details/controller/detail_controller.dart';

class UnitsStep extends StatefulWidget {
  final DetailController controller;
  const UnitsStep({super.key, required this.controller});

  @override
  State<UnitsStep> createState() => _UnitsStepState();
}

class _UnitsStepState extends State<UnitsStep> {
  String _selectedGlucoseUnit = 'mg/dL';
  String _selectedCarbsUnit = 'g';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'What units do you use?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: const Text(
              "If you're not sure what units are right for you, ask your healthcare professional.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 32),
          _buildSectionTitle('Glucose'),
          const SizedBox(height: 12),
          _buildUnitSelector(
            units: ['mg/dL', 'mmol/L'],
            selectedUnit: _selectedGlucoseUnit,
            onSelect: (unit) {
              setState(() {
                _selectedGlucoseUnit = unit;
              });
            },
          ),
          const SizedBox(height: 32),
          _buildSectionTitle('Carbs'),
          const SizedBox(height: 12),
          _buildUnitSelector(
            units: ['g', 'ex'],
            selectedUnit: _selectedCarbsUnit,
            onSelect: (unit) {
              setState(() {
                _selectedCarbsUnit = unit;
              });
            },
          ),
          const Spacer(),
          FloatingActionButton(
            onPressed: () {
              widget.controller.model.glucoseUnit = _selectedGlucoseUnit;
              widget.controller.model.carbsUnit = _selectedCarbsUnit;
              // This should now be the final step, so we call saveDetails
              widget.controller.saveDetails(context);
            },
            // Using a checkmark icon to signify the final step
            child: const Icon(Icons.check),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildUnitSelector({
    required List<String> units,
    required String selectedUnit,
    required ValueChanged<String> onSelect,
  }) {
    return Row(
      children: units.map((unit) {
        final isSelected = selectedUnit == unit;
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelect(unit),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              child: Text(
                unit,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
