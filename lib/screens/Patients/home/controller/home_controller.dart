import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/home_model.dart';

class HomeController {
  final ValueNotifier<HomeModel> modelNotifier;

  HomeController()
    : modelNotifier = ValueNotifier(HomeModel(selectedDate: DateTime.now()));

  void loadHomeData() {
    _updateAnalytics();
  }

  void onDateSelected(DateTime newDate) {
    modelNotifier.value = modelNotifier.value.copyWith(selectedDate: newDate);
    _updateAnalytics();
  }

  void changeViewType(AnalyticsViewType newType) {
    if (modelNotifier.value.currentViewType != newType) {
      modelNotifier.value = modelNotifier.value.copyWith(
        currentViewType: newType,
      );
      _updateAnalytics();
    }
  }

  Future<void> _updateAnalytics() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final viewType = modelNotifier.value.currentViewType;
    final selectedDate = modelNotifier.value.selectedDate;

    modelNotifier.value = modelNotifier.value.copyWith(
      analyticsSummary: 'Loading...',
      chartData: [],
      dailyTasks: [],
    );

    try {
      final query = FirebaseFirestore.instance
          .collection('patients')
          .doc(user.uid)
          .collection('routine_completions');

      switch (viewType) {
        case AnalyticsViewType.day:
          await _generateDayAnalytics(query, selectedDate);
          break;
        case AnalyticsViewType.month:
          await _generateMonthAnalytics(query, selectedDate);
          break;
        case AnalyticsViewType.year:
          await _generateYearAnalytics(query, selectedDate);
          break;
      }
    } catch (e) {
      modelNotifier.value = modelNotifier.value.copyWith(
        analyticsSummary: 'Error loading data.',
      );
    }
  }

  // --- MODIFIED: This method now provides dynamic feedback ---
  Future<void> _generateDayAnalytics(Query query, DateTime date) async {
    final dateString = DateFormat('yyyy-MM-dd').format(date);
    final snapshot = await query
        .where('completionDate', isEqualTo: dateString)
        .get();

    double totalImpact = 0;
    List<String> tasks = [];

    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        totalImpact += doc['glucoseImpact'] ?? 0;
        tasks.add(doc['levelTitle'] ?? 'Completed Task');
      }

      String summary;
      // Check if the net impact is positive, negative, or neutral
      if (totalImpact > 0.1) {
        // Using a small threshold to avoid floating point issues
        summary =
            "Today's net glucose impact is an estimated increase of ${totalImpact.toStringAsFixed(1)} mg/dL.";
      } else if (totalImpact < -0.1) {
        // Display the decrease as a positive number
        summary =
            "Today's net glucose impact is an estimated decrease of ${(-totalImpact).toStringAsFixed(1)} mg/dL.";
      } else {
        summary = "Today's net glucose impact is estimated to be neutral.";
      }

      modelNotifier.value = modelNotifier.value.copyWith(
        analyticsSummary: summary,
        dailyTasks: tasks,
        chartData: [],
      );
    } else {
      modelNotifier.value = modelNotifier.value.copyWith(
        analyticsSummary: 'No routine data recorded for this day.',
        dailyTasks: [],
        chartData: [],
      );
    }
  }

  Future<void> _generateMonthAnalytics(Query query, DateTime date) async {
    final startOfMonth = DateTime(date.year, date.month, 1);
    final endOfMonth = DateTime(date.year, date.month + 1, 0, 23, 59, 59);

    final snapshot = await query
        .where(
          'completedAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth),
        )
        .where(
          'completedAt',
          isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth),
        )
        .get();

    if (snapshot.docs.isEmpty) {
      modelNotifier.value = modelNotifier.value.copyWith(
        analyticsSummary: 'No data for this month.',
        chartData: [],
      );
      return;
    }

    Map<int, double> weeklyData = {};
    for (var doc in snapshot.docs) {
      final docDate = (doc['completedAt'] as Timestamp).toDate();
      final weekNumber = ((docDate.day - 1) / 7).floor() + 1;
      weeklyData.update(
        weekNumber,
        (value) => value + (doc['glucoseImpact'] ?? 0),
        ifAbsent: () => doc['glucoseImpact'] ?? 0,
      );
    }

    List<FlSpot> spots = weeklyData.entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
        .toList();
    spots.sort((a, b) => a.x.compareTo(b.x));

    modelNotifier.value = modelNotifier.value.copyWith(
      analyticsSummary:
          'Weekly net glucose impact for ${DateFormat('MMMM yyyy').format(date)}.',
      chartData: spots,
    );
  }

  Future<void> _generateYearAnalytics(Query query, DateTime date) async {
    final startOfYear = DateTime(date.year, 1, 1);
    final endOfYear = DateTime(date.year, 12, 31, 23, 59, 59);
    final snapshot = await query
        .where(
          'completedAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfYear),
        )
        .where(
          'completedAt',
          isLessThanOrEqualTo: Timestamp.fromDate(endOfYear),
        )
        .get();

    if (snapshot.docs.isEmpty) {
      modelNotifier.value = modelNotifier.value.copyWith(
        analyticsSummary: 'No data for this year.',
        chartData: [],
      );
      return;
    }

    Map<int, double> monthlyData = {};
    for (var doc in snapshot.docs) {
      final docDate = (doc['completedAt'] as Timestamp).toDate();
      final month = docDate.month;
      monthlyData.update(
        month,
        (value) => value + (doc['glucoseImpact'] ?? 0),
        ifAbsent: () => doc['glucoseImpact'] ?? 0,
      );
    }

    List<FlSpot> spots = monthlyData.entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
        .toList();
    spots.sort((a, b) => a.x.compareTo(b.x));

    modelNotifier.value = modelNotifier.value.copyWith(
      analyticsSummary: 'Monthly net glucose impact trend for ${date.year}.',
      chartData: spots,
    );
  }

  void dispose() {
    modelNotifier.dispose();
  }
}
