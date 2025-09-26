import 'package:flutter/material.dart';
import 'package:glycosync/screens/Patients/routine/controller/routine_controller.dart';
import 'package:glycosync/screens/Patients/routine/model/routine_model.dart';
import 'package:glycosync/screens/Patients/routine/view/task_list_view.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class RoutineView extends StatefulWidget {
  const RoutineView({super.key});

  @override
  State<RoutineView> createState() => _RoutineViewState();
}

class _RoutineViewState extends State<RoutineView> {
  late final RoutineController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RoutineController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6), // Your cream background
      appBar: AppBar(
        title: const Text(
          "Today's Routine",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        backgroundColor: const Color(0xFF6D94C5), // Your medium blue
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ValueListenableBuilder<RoutineModel>(
        valueListenable: _controller.modelNotifier,
        builder: (context, model, child) {
          // --- NEW: Calculate totals from completed tasks ---
          double totalCalories = 0;
          double totalProtein = 0;
          double totalCarbs = 0;
          double totalFat = 0;

          for (var level in model.levels) {
            if (level.status == LevelStatus.completed) {
              for (var task in level.subTasks) {
                totalCalories += task.calories ?? 0;
                totalProtein += task.protein ?? 0;
                totalCarbs += task.carbs ?? 0;
                totalFat += task.fat ?? 0;
              }
            }
          }

          // --- MODIFIED: Wrap ListView in a Column ---
          return Column(
            children: [
              // --- NEW: Display the nutrition summary card ---
              // Only show the card if some nutrition has been logged
              if (totalCalories > 0)
                _buildNutritionSummary(
                  context,
                  calories: totalCalories,
                  protein: totalProtein,
                  carbs: totalCarbs,
                  fat: totalFat,
                ),

              // --- MODIFIED: Put ListView inside an Expanded widget ---
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: model.levels.length,
                  itemBuilder: (context, index) {
                    final level = model.levels[index];
                    return _buildLevelCard(context, level, index);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- NEW: Nutrition Summary Card Widget ---
  Widget _buildNutritionSummary(
    BuildContext context, {
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nutrition Gained Today',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6D94C5), // Your medium blue
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNutritionStat(
                  'Calories',
                  '${calories.toStringAsFixed(0)} kcal',
                ),
                _buildNutritionStat(
                  'Protein',
                  '${protein.toStringAsFixed(1)}g',
                ),
                _buildNutritionStat('Carbs', '${carbs.toStringAsFixed(1)}g'),
                _buildNutritionStat('Fat', '${fat.toStringAsFixed(1)}g'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF6D94C5), // Your medium blue
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6D94C5), // Your medium blue for consistency
          ),
        ),
      ],
    );
  }

  Widget _buildLevelCard(
    BuildContext context,
    RoutineLevel level,
    int levelIndex,
  ) {
    final bool isLocked = level.status == LevelStatus.locked;
    final bool isCompleted = level.status == LevelStatus.completed;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isLocked
            ? null // Disable tap if locked
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskListView(
                      controller: _controller,
                      level: level,
                      levelIndex: levelIndex,
                    ),
                  ),
                );
              },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Opacity(
            opacity: isLocked ? 0.5 : 1.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isCompleted
                          ? Icons.check_circle
                          : (isLocked ? Icons.lock : level.icon),
                      color: isCompleted
                          ? const Color(
                              0xFF6D94C5,
                            ) // Your medium blue for completed
                          : (isLocked
                                ? Colors.grey
                                : const Color(0xFF6D94C5)), // Your medium blue
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            level.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6D94C5), // Your medium blue
                            ),
                          ),
                          Text(
                            level.timeRange,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6D94C5), // Your medium blue
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isLocked)
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                if (!isLocked)
                  LinearPercentIndicator(
                    percent: level.completionPercentage,
                    lineHeight: 8.0,
                    barRadius: const Radius.circular(4),
                    backgroundColor: const Color(0xFFCBDCEB), // Your light blue
                    progressColor: const Color(0xFF6D94C5), // Your medium blue
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
