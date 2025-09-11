import 'package:fl_chart/fl_chart.dart';

// Enum to define the different time ranges for analytics.
enum AnalyticsViewType { day, month, year }

// Represents all the data needed for the Home View.
class HomeModel {
  final String welcomeMessage;
  final String analyticsSummary; // Unified summary for all views
  final DateTime selectedDate;
  final AnalyticsViewType currentViewType;
  final List<String> dailyTasks; // For the "Day" view's task list
  final List<FlSpot> chartData; // Unified chart data for month/year views

  // Constructor with initial default values.
  HomeModel({
    this.welcomeMessage = 'Hello, User! \nHave a pleasant day.',
    this.analyticsSummary = 'Loading analytics...',
    this.dailyTasks = const [],
    this.chartData = const [],
    required this.selectedDate,
    this.currentViewType = AnalyticsViewType.day,
  });

  // A helper method to create a copy of the model with updated values.
  HomeModel copyWith({
    String? welcomeMessage,
    String? analyticsSummary,
    DateTime? selectedDate,
    AnalyticsViewType? currentViewType,
    List<String>? dailyTasks,
    List<FlSpot>? chartData,
  }) {
    return HomeModel(
      welcomeMessage: welcomeMessage ?? this.welcomeMessage,
      analyticsSummary: analyticsSummary ?? this.analyticsSummary,
      selectedDate: selectedDate ?? this.selectedDate,
      currentViewType: currentViewType ?? this.currentViewType,
      dailyTasks: dailyTasks ?? this.dailyTasks,
      chartData: chartData ?? this.chartData,
    );
  }
}

