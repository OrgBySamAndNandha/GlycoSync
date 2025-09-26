import 'package:flutter/material.dart';

// Enum to differentiate between content types
enum ContentType { workout, ayurveda }

// A class to structure the key benefits for both workouts and articles
class KeyBenefit {
  final String title;
  final String description;

  KeyBenefit(this.title, this.description);
}

// The main model for all content within the Empowerment Hub
class EmpowermentContent {
  final String title;
  final String description;
  final ContentType type;
  final IconData icon;

  // Properties specifically for workout videos
  final String? youtubeVideoId;
  final String? videoPath; // Local video asset path
  final String? difficulty;
  final String? duration;

  // Properties specifically for rich Ayurveda articles
  final String? imagePath;
  final String? howToUse;
  final String? sourceUrl;

  // This property is used by both workouts and articles
  final List<KeyBenefit>? benefits;

  // --- THIS IS THE FIX ---
  // The constructor is updated to include all new properties.
  EmpowermentContent({
    required this.title,
    required this.description,
    required this.type,
    required this.icon,
    this.youtubeVideoId,
    this.videoPath,
    this.difficulty,
    this.duration,
    this.imagePath,
    this.howToUse,
    this.sourceUrl,
    this.benefits,
  });
}
