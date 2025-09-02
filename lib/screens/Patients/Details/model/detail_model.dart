class DetailModel {
  // Personal Info
  DateTime? dateOfBirth;
  String gender;
  String height;
  String weight;

  // Diabetes Profile
  String diabetesType;
  int? diagnosisYear;
  String insulinTherapy;
  bool takesPills;
  String glucoseMeter;

  // App Preferences
  String glucoseUnit;
  String carbsUnit;

  // New field for health goals
  List<String> healthGoals;

  DetailModel({
    this.dateOfBirth,
    this.gender = '',
    this.height = '',
    this.weight = '',
    this.diabetesType = '',
    this.diagnosisYear,
    this.insulinTherapy = '',
    this.takesPills = false,
    this.glucoseMeter = '',
    this.glucoseUnit = 'mg/dL',
    this.carbsUnit = 'g',
    this.healthGoals = const [], // Initialize as an empty list
  });

  Map<String, dynamic> toMap() {
    return {
      'gender': gender,
      'height': height,
      'weight': weight,
      'diabetesType': diabetesType,
      'takesPills': takesPills,
      'insulinTherapy': insulinTherapy,
      'glucoseUnit': glucoseUnit,
      'carbsUnit': carbsUnit,
      'healthGoals': healthGoals,
      // Add other fields as needed
    };
  }
}

