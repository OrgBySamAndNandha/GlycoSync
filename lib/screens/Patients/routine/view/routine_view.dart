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
      appBar: AppBar(
        title: Text(
          "Today's Routine",
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: ValueListenableBuilder<RoutineModel>(
        valueListenable: _controller.modelNotifier,
        builder: (context, model, child) {
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: model.levels.length,
            itemBuilder: (context, index) {
              final level = model.levels[index];
              return _buildLevelCard(context, level, index);
            },
          );
        },
      ),
    );
  }

  Widget _buildLevelCard(
      BuildContext context, RoutineLevel level, int levelIndex) {
    final bool isLocked = level.status == LevelStatus.locked;
    final bool isCompleted = level.status == LevelStatus.completed;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                          ? Colors.green
                          : (isLocked
                              ? Colors.grey
                              : Theme.of(context).primaryColor),
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            level.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            level.timeRange,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    if (!isLocked)
                      const Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 12),
                if (!isLocked)
                  LinearPercentIndicator(
                    percent: level.completionPercentage,
                    lineHeight: 8.0,
                    barRadius: const Radius.circular(4),
                    backgroundColor: Colors.grey.shade300,
                    progressColor: Colors.green,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

