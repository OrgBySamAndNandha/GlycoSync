// Enum to define the different time ranges for analytics.
enum AnalyticsViewType { day, month, year }

// Represents all the data needed for the Home View.
class HomeModel {
  final String welcomeMessage;
  final String analyticsSummary;
  final DateTime selectedDate;
  final AnalyticsViewType currentViewType;
  final List<String> dailyTasks; // To hold tasks for the selected day

  // Constructor with initial default values.
  HomeModel({
    this.welcomeMessage = '',
    this.analyticsSummary = 'Loading analytics...',
    this.dailyTasks = const [],
    required this.selectedDate,
    this.currentViewType = AnalyticsViewType.day,
  });

  // A helper method to create a copy of the model with updated values.
  // This is useful for state management.
  HomeModel copyWith({
    String? welcomeMessage,
    String? analyticsSummary,
    DateTime? selectedDate,
    AnalyticsViewType? currentViewType,
    List<String>? dailyTasks,
  }) {
    return HomeModel(
      welcomeMessage: welcomeMessage ?? this.welcomeMessage,
      analyticsSummary: analyticsSummary ?? this.analyticsSummary,
      selectedDate: selectedDate ?? this.selectedDate,
      currentViewType: currentViewType ?? this.currentViewType,
      dailyTasks: dailyTasks ?? this.dailyTasks,
    );
  }
}
