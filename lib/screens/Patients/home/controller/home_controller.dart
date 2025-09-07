import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/home_model.dart';

class HomeController {
  final ValueNotifier<HomeModel> modelNotifier;

  HomeController()
    : modelNotifier = ValueNotifier(HomeModel(selectedDate: DateTime.now()));

  // A single method to update the displayed data.
  void _updateData() {
    final currentModel = modelNotifier.value;
    final selectedDate = currentModel.selectedDate;
    final viewType = currentModel.currentViewType;

    String newSummary = '';
    List<String> newTasks = [];

    // Generate different data based on the selected view type.
    switch (viewType) {
      case AnalyticsViewType.day:
        newSummary =
            "Today's routine adherence is at 80%. Glucose levels are stable.";
        // Dummy tasks for the selected day
        newTasks = [
          '6:30 AM - Wake up & drink lemon water',
          '7:00 AM - Morning workout',
          '8:30 AM - Healthy Breakfast',
          '1:00 PM - Lunch & short walk',
        ];
        break;
      case AnalyticsViewType.month:
        newSummary =
            "In ${DateFormat('MMMM').format(selectedDate)}, you've had a 92% adherence rate. Keep up the great work!";
        break;
      case AnalyticsViewType.year:
        newSummary =
            "Your overall health trend for ${selectedDate.year} is positive, with significant improvements since Q1.";
        break;
    }

    // Update the model, which will notify the view.
    modelNotifier.value = currentModel.copyWith(
      welcomeMessage: 'Hello, User! \nHave a pleasant day.',
      analyticsSummary: newSummary,
      dailyTasks: newTasks,
    );
  }

  // Called when the screen first loads.
  void loadHomeData() {
    _updateData();
  }

  // Called when the user selects a new date on the calendar.
  void onDateSelected(DateTime newDate) {
    modelNotifier.value = modelNotifier.value.copyWith(selectedDate: newDate);
    _updateData(); // Refresh data for the new date
  }

  // Called when the user taps on "Day", "Month", or "Year".
  void changeViewType(AnalyticsViewType newType) {
    modelNotifier.value = modelNotifier.value.copyWith(
      currentViewType: newType,
    );
    _updateData(); // Refresh data for the new view type
  }

  void dispose() {
    modelNotifier.dispose();
  }
}
