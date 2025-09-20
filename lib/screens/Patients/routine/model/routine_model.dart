import 'package:flutter/material.dart';

// Represents the overall state of the routine screen
class RoutineModel {
  final List<RoutineLevel> levels;

  RoutineModel({required this.levels});

  // Helper for immutable state updates
  RoutineModel copyWith({List<RoutineLevel>? levels}) {
    return RoutineModel(levels: levels ?? this.levels);
  }
}

// Represents one level in the daily routine
class RoutineLevel {
  final String title;
  final String timeRange;
  final IconData icon;
  final List<SubTask> subTasks;
  LevelStatus status;

  RoutineLevel({
    required this.title,
    required this.timeRange,
    required this.icon,
    required this.subTasks,
    this.status = LevelStatus.locked,
  });

  // Calculates completion percentage for the progress bar
  double get completionPercentage {
    if (subTasks.isEmpty) return 0.0;
    final completedCount = subTasks.where((task) => task.isCompleted).length;
    return completedCount / subTasks.length;
  }

  // Checks if all tasks in the level are done
  bool get areAllSubTasksCompleted =>
      subTasks.every((task) => task.isCompleted);
}

// Represents a single task within a level
class SubTask {
  final String title;
  final String description;
  final List<String>? ingredients;
  final List<String> instructions;
  final String rationale;
  final String? gifPath;
  final double glucoseImpact; // Crucial for analytics
  bool isCompleted;

  // --- NEW: Nutritional Information ---
  // Added nullable fields for nutritional data.
  // Not all tasks (like exercise) will have this data.
  final double? calories;
  final double? protein;
  final double? carbs;
  final double? fat;

  SubTask({
    required this.title,
    required this.description,
    this.ingredients,
    required this.instructions,
    required this.rationale,
    this.gifPath,
    required this.glucoseImpact,
    this.isCompleted = false,
    // --- NEW: Added to constructor ---
    this.calories,
    this.protein,
    this.carbs,
    this.fat,
  });
}

// Defines the state of a level (locked, unlocked, completed)
enum LevelStatus { locked, unlocked, completed }
