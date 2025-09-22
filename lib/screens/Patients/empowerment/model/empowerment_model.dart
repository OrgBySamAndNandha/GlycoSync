import 'package:flutter/material.dart';

// Enum to differentiate between content types
enum ContentType { workout, ayurveda }

class EmpowermentContent {
  final String title;
  final String description;
  final ContentType type;
  final IconData icon;
  final String? gifPath; // For workouts
  final List<String> instructions; // For workouts
  final String? detailedDoc; // For Ayurveda articles

  EmpowermentContent({
    required this.title,
    required this.description,
    required this.type,
    required this.icon,
    this.gifPath,
    this.instructions = const [],
    this.detailedDoc,
  });
}
