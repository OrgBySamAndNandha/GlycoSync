class GlucoseRecord {
  final DateTime date;
  final double glucoseImpact;
  final String activityType;

  const GlucoseRecord({
    required this.date,
    required this.glucoseImpact,
    required this.activityType,
  });

  factory GlucoseRecord.fromJson(Map<String, dynamic> json) {
    return GlucoseRecord(
      date: DateTime.parse(json['date'] as String),
      activityType: json['activityType'] as String,
      glucoseImpact: (json['glucoseImpact'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'activityType': activityType,
      'glucoseImpact': glucoseImpact,
    };
  }
}
