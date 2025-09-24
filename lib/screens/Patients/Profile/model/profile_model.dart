import 'package:flutter/foundation.dart';

// Represents the data for a single day in the weekly report.
class DailyReportData {
  final DateTime date;
  final double netGlucoseImpact;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final List<String> completedLevels;

  const DailyReportData({
    required this.date,
    this.netGlucoseImpact = 0.0,
    this.totalProtein = 0.0,
    this.totalCarbs = 0.0,
    this.totalFat = 0.0,
    this.completedLevels = const [],
  });
}

// Class to hold lab report data
class LabReportData {
  final String hba1c;
  final String avgBloodGlucose;
  final String fastingBloodSugar;

  const LabReportData({
    this.hba1c = '-',
    this.avgBloodGlucose = '-',
    this.fastingBloodSugar = '-',
  });
}

// Represents all the data needed for the Profile View.
class ProfileModel {
  final String patientName;
  final String patientEmail;
  final String diabetesType;
  final String height;
  final String weight;
  final bool isLoading;
  final List<DailyReportData> weeklyReportData;
  final LabReportData labReportData;
  // --- NEW: To track the date of the last report ---
  final DateTime? lastReportDate;

  const ProfileModel({
    this.patientName = 'Loading...',
    this.patientEmail = 'Loading...',
    this.diabetesType = '-',
    this.height = '-',
    this.weight = '-',
    this.isLoading = true,
    this.weeklyReportData = const [],
    this.labReportData = const LabReportData(),
    // --- NEW: Initialize in constructor ---
    this.lastReportDate,
  });

  // Helper method for immutable updates.
  ProfileModel copyWith({
    String? patientName,
    String? patientEmail,
    String? diabetesType,
    String? height,
    String? weight,
    bool? isLoading,
    List<DailyReportData>? weeklyReportData,
    LabReportData? labReportData,
    // --- NEW: Add to copyWith ---
    DateTime? lastReportDate,
  }) {
    return ProfileModel(
      patientName: patientName ?? this.patientName,
      patientEmail: patientEmail ?? this.patientEmail,
      diabetesType: diabetesType ?? this.diabetesType,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      isLoading: isLoading ?? this.isLoading,
      weeklyReportData: weeklyReportData ?? this.weeklyReportData,
      labReportData: labReportData ?? this.labReportData,
      // --- NEW: Update lastReportDate ---
      lastReportDate: lastReportDate ?? this.lastReportDate,
    );
  }
}
