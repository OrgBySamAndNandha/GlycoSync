import 'package:fl_chart/fl_chart.dart';

// Represents all the data needed for the Home View.
class HomeModel {
  final String welcomeMessage;
  final String analyticsSummary; // For glucose impact text
  final DateTime selectedDate;
  final List<String> dailyTasks; // For the list of completed levels

  // --- NEW: Fields for nutrition data ---
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;

  // Constructor with initial default values.
  HomeModel({
    this.welcomeMessage = 'Hello, User! \nHave a pleasant day.',
    this.analyticsSummary = 'Loading analytics...',
    this.dailyTasks = const [],
    required this.selectedDate,
    // --- NEW: Initialize nutrition data ---
    this.totalProtein = 0.0,
    this.totalCarbs = 0.0,
    this.totalFat = 0.0,
  });

  // A helper method to create a copy of the model with updated values.
  HomeModel copyWith({
    String? welcomeMessage,
    String? analyticsSummary,
    DateTime? selectedDate,
    List<String>? dailyTasks,
    // --- NEW: Add nutrition to copyWith ---
    double? totalProtein,
    double? totalCarbs,
    double? totalFat,
  }) {
    return HomeModel(
      welcomeMessage: welcomeMessage ?? this.welcomeMessage,
      analyticsSummary: analyticsSummary ?? this.analyticsSummary,
      selectedDate: selectedDate ?? this.selectedDate,
      dailyTasks: dailyTasks ?? this.dailyTasks,
      totalProtein: totalProtein ?? this.totalProtein,
      totalCarbs: totalCarbs ?? this.totalCarbs,
      totalFat: totalFat ?? this.totalFat,
    );
  }
}
