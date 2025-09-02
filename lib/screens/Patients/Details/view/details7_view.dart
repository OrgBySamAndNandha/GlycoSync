import 'package:flutter/material.dart';
import 'package:glycosync/screens/Patients/Details/controller/detail_controller.dart';

class GoalsStep extends StatefulWidget {
  final DetailController controller;
  const GoalsStep({super.key, required this.controller});

  @override
  State<GoalsStep> createState() => _GoalsStepState();
}

class _GoalsStepState extends State<GoalsStep> {
  final List<String> _selectedGoals = [];

  // Helper map to associate goals with icons
  final Map<String, IconData> _goalOptions = {
    'Weight loss': Icons.monitor_weight_outlined,
    'Mindful Eating/Intuitive eating': Icons.restaurant_menu_outlined,
    'Gut Health': Icons.cloud_outlined,
    'Insulin Resistance': Icons.vaccines_outlined,
    "Women's Health (Menopause, PCOS, Fertility)": Icons.female_outlined,
    'Manage Pre Diabetes/Diabetes': Icons.bloodtype_outlined,
  };

  void _toggleGoal(String goal) {
    setState(() {
      if (_selectedGoals.contains(goal)) {
        _selectedGoals.remove(goal);
      } else {
        _selectedGoals.add(goal);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'What can we help you with?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: _goalOptions.length,
              itemBuilder: (context, index) {
                final goal = _goalOptions.keys.elementAt(index);
                final icon = _goalOptions[goal]!;
                final isSelected = _selectedGoals.contains(goal);
                return _buildGoalTile(goal, icon, isSelected);
              },
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 16, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                'All details you share are secure and confidential',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              widget.controller.model.healthGoals = _selectedGoals;
              widget.controller.saveDetails(context);
            },
            child: const Icon(Icons.check),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildGoalTile(String title, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () => _toggleGoal(title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: Theme.of(context).primaryColor, width: 2)
              : Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ]
              : [],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Theme.of(context).primaryColor : Colors.black54,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
