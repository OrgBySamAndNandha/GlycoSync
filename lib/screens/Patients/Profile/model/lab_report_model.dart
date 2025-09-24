import 'package:cloud_firestore/cloud_firestore.dart';

class LabReportSubmission {
  final String hba1c;
  final String avgBloodGlucose;
  final String fastingBloodSugar;
  final DateTime reportDate;

  LabReportSubmission({
    required this.hba1c,
    required this.avgBloodGlucose,
    required this.fastingBloodSugar,
    required this.reportDate,
  });

  factory LabReportSubmission.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LabReportSubmission(
      hba1c: data['hba1c'] ?? '-',
      avgBloodGlucose: data['avgBloodGlucose'] ?? '-',
      fastingBloodSugar: data['fastingBloodSugar'] ?? '-',
      reportDate: (data['reportDate'] as Timestamp).toDate(),
    );
  }
}
