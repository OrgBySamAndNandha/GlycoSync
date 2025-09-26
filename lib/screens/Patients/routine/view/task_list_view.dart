import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:glycosync/screens/Patients/routine/controller/routine_controller.dart';
import 'package:glycosync/screens/Patients/routine/model/routine_model.dart';
import 'package:glycosync/screens/Patients/routine/view/task_detail_view.dart';

class TaskListView extends StatelessWidget {
  final RoutineController controller;
  final RoutineLevel level;
  final int levelIndex;

  const TaskListView({
    super.key,
    required this.controller,
    required this.level,
    required this.levelIndex,
  });

  void _showTaskDetails(BuildContext context, SubTask task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => TaskDetailView(task: task),
    );
  }

  // Helper method to get the appropriate animation based on level
  String _getAnimationPath() {
    switch (levelIndex) {
      case 0: // Level 1: Morning Rise
        return 'assets/gifs/Girl yoga.json';
      case 1: // Level 2: Balanced Breakfast
        return 'assets/animations/Nutrition.json';
      case 2: // Level 3: Mid-Morning Snack
        return 'assets/animations/Thanksgiving Basket.json';
      case 3: // Level 4
        return 'assets/animations/food.json';
      case 4: // Level 5
        return 'assets/gifs/desk_stretch.json';
      case 5: // Level 6
        return 'assets/gifs/walking.json';
      case 6: // Level 7
        return 'assets/animations/sleepiness.json';
      default:
        return 'assets/gifs/Girl yoga.json'; // Default fallback
    }
  }

  // Helper method to get the appropriate error icon based on level
  IconData _getErrorIcon() {
    switch (levelIndex) {
      case 0: // Level 1: Morning Rise
        return Icons.self_improvement;
      case 1: // Level 2: Balanced Breakfast
        return Icons.restaurant;
      case 2: // Level 3: Mid-Morning Snack
        return Icons.eco;
      case 3: // Level 4
        return Icons.fastfood;
      case 4: // Level 5
        return Icons.accessibility_new;
      case 5: // Level 6
        return Icons.directions_walk;
      case 6: // Level 7
        return Icons.bedtime;
      default:
        return Icons.self_improvement; // Default fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6), // Your cream background
      appBar: AppBar(
        title: Text(
          level.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFF6D94C5), // Your medium blue
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ValueListenableBuilder<RoutineModel>(
        // Listen to the controller's notifier to rebuild on state change
        valueListenable: controller.modelNotifier,
        builder: (context, model, child) {
          // Find the latest version of the level from the model
          final currentLevel = model.levels[levelIndex];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Task list
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: currentLevel.subTasks.length,
                  itemBuilder: (context, subTaskIndex) {
                    final task = currentLevel.subTasks[subTaskIndex];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      color: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CheckboxListTile(
                        title: Text(
                          task.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6D94C5), // Your medium blue
                          ),
                        ),
                        subtitle: Text(
                          task.description,
                          style: const TextStyle(
                            color: Color(0xFF6D94C5), // Your medium blue
                          ),
                        ),
                        value: task.isCompleted,
                        activeColor: const Color(
                          0xFF6D94C5,
                        ), // Your medium blue for checkbox
                        onChanged: (bool? value) {
                          if (value != null) {
                            controller.toggleSubTaskCompletion(
                              levelIndex,
                              subTaskIndex,
                              value,
                            );
                          }
                        },
                        secondary: IconButton(
                          icon: const Icon(
                            Icons.info_outline,
                            color: Color(0xFF6D94C5), // Your medium blue
                          ),
                          onPressed: () => _showTaskDetails(context, task),
                        ),
                      ),
                    );
                  },
                ),

                // Add more spacing to lower the gif
                const SizedBox(height: 60),

                // Animation section - blended with background (bigger size)
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Lottie.asset(
                    _getAnimationPath(),
                    fit: BoxFit.contain,
                    repeat: true,
                    animate: true,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          _getErrorIcon(),
                          size: 80,
                          color: const Color(0xFF6D94C5),
                        ),
                      );
                    },
                  ),
                ),

                // Add bottom padding to avoid button overlap
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            controller.completeLevel(context, levelIndex);
            // The controller will pop the navigation if successful
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6D94C5), // Your medium blue
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Complete Level',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
