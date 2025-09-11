import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(level.title),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: ValueListenableBuilder<RoutineModel>(
        // Listen to the controller's notifier to rebuild on state change
        valueListenable: controller.modelNotifier,
        builder: (context, model, child) {
          // Find the latest version of the level from the model
          final currentLevel = model.levels[levelIndex];

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: currentLevel.subTasks.length,
            itemBuilder: (context, subTaskIndex) {
              final task = currentLevel.subTasks[subTaskIndex];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: CheckboxListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  value: task.isCompleted,
                  onChanged: (bool? value) {
                    if (value != null) {
                      controller.toggleSubTaskCompletion(
                          levelIndex, subTaskIndex, value);
                    }
                  },
                  secondary: IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () => _showTaskDetails(context, task),
                  ),
                ),
              );
            },
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
          child: const Text('Complete Level'),
        ),
      ),
    );
  }
}

