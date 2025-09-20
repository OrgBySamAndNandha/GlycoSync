import '../model/profile_model.dart';
import '../model/glucose_record.dart';

class ProfileService {
  Future<ProfileModel> fetchProfileData() async {
    // TODO: Replace this with actual API call or Firebase fetch
    // Simulated API delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock data
    return ProfileModel(
      name: 'John Doe',
      email: 'john.doe@example.com',
      age: 35,
      gender: 'Male',
      weight: 75.5,
      height: 175.0,
      initialGlucoseLevel: 120.0,
      currentPredictedGlucose: 115.5,
      glucoseTrend: 'Stable',
      averageDailyChange: -0.5,
      glucoseHistory: [
        GlucoseRecord(
          date: DateTime.now().subtract(const Duration(days: 1)),
          activityType: 'Exercise',
          glucoseImpact: -5.0,
        ),
        GlucoseRecord(
          date: DateTime.now().subtract(const Duration(days: 2)),
          activityType: 'High Carb Meal',
          glucoseImpact: 8.5,
        ),
        GlucoseRecord(
          date: DateTime.now().subtract(const Duration(days: 3)),
          activityType: 'Medication',
          glucoseImpact: -3.2,
        ),
      ],
    );
  }
}
