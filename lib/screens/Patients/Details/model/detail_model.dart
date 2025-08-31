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
  });
}

