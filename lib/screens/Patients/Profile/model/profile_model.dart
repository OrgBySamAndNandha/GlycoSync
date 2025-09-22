import 'package:flutter/foundation.dart';

// Represents the data for a single day in the weekly report.
class DailyReportData {
  final DateTime date;
  final double netGlucoseImpact;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;

  DailyReportData({
    required this.date,
    this.netGlucoseImpact = 0.0,
    this.totalProtein = 0.0,
    this.totalCarbs = 0.0,
    this.totalFat = 0.0,
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

  ProfileModel({
    this.patientName = 'Loading...',
    this.patientEmail = 'Loading...',
    this.diabetesType = '-',
    this.height = '-',
    this.weight = '-',
    this.isLoading = true,
    this.weeklyReportData = const [],
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
  }) {
    return ProfileModel(
      patientName: patientName ?? this.patientName,
      patientEmail: patientEmail ?? this.patientEmail,
      diabetesType: diabetesType ?? this.diabetesType,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      isLoading: isLoading ?? this.isLoading,
      weeklyReportData: weeklyReportData ?? this.weeklyReportData,
    );
  }
}
