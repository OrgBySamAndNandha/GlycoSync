import 'glucose_record.dart';

class ProfileModel {
  final String name;
  final String email;
  final int age;
  final double weight;
  final double height;
  final String gender;
  final double initialGlucoseLevel;
  final double currentPredictedGlucose;
  final String glucoseTrend;
  final double averageDailyChange;
  final List<GlucoseRecord> glucoseHistory;

  const ProfileModel({
    required this.name,
    required this.email,
    required this.age,
    required this.weight,
    required this.height,
    required this.gender,
    required this.initialGlucoseLevel,
    required this.currentPredictedGlucose,
    required this.glucoseTrend,
    required this.averageDailyChange,
    required this.glucoseHistory,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'] as String,
      email: json['email'] as String,
      age: json['age'] as int,
      gender: json['gender'] as String,
      weight: (json['weight'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      initialGlucoseLevel: (json['initialGlucoseLevel'] as num).toDouble(),
      currentPredictedGlucose: (json['currentPredictedGlucose'] as num)
          .toDouble(),
      glucoseTrend: json['glucoseTrend'] as String,
      averageDailyChange: (json['averageDailyChange'] as num).toDouble(),
      glucoseHistory: (json['glucoseHistory'] as List)
          .map((e) => GlucoseRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'age': age,
      'gender': gender,
      'weight': weight,
      'height': height,
      'initialGlucoseLevel': initialGlucoseLevel,
      'currentPredictedGlucose': currentPredictedGlucose,
      'glucoseTrend': glucoseTrend,
      'averageDailyChange': averageDailyChange,
      'glucoseHistory': glucoseHistory.map((e) => e.toJson()).toList(),
    };
  }
}
