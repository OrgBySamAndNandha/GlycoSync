import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glycosync/screens/Patients/auth/view/Login_view.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glycosync/screens/Patients/routine/model/routine_model.dart';
import '../model/profile_model.dart';

class ProfileController {
  final ValueNotifier<ProfileModel> modelNotifier = ValueNotifier(
    ProfileModel(),
  );

  final RoutineModel _routineData =
      _getInitialRoutineData(); // Master routine data

  // Fetches initial profile and report data for the current week.
  Future<void> fetchProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    modelNotifier.value = modelNotifier.value.copyWith(isLoading: true);

    try {
      // Fetch patient details from both collections
      final patientDoc = await FirebaseFirestore.instance
          .collection('patients')
          .doc(user.uid)
          .get();
      final patientDetailsDoc = await FirebaseFirestore.instance
          .collection('patients_details')
          .doc(user.uid)
          .get();

      final patientData = patientDoc.data();
      final patientDetailsData = patientDetailsDoc.data();

      // Fetch the report for the current week
      final weeklyData = await fetchWeeklyReport(DateTime.now());

      modelNotifier.value = modelNotifier.value.copyWith(
        patientName: patientData?['name'] ?? 'No Name',
        patientEmail: patientData?['email'] ?? 'No Email',
        diabetesType: patientDetailsData?['diabetesType'] ?? '-',
        height: patientDetailsData?['height'] ?? '-',
        weight: patientDetailsData?['weight'] ?? '-',
        weeklyReportData: weeklyData,
        isLoading: false,
      );
    } catch (e) {
      debugPrint('Error fetching profile data: $e');
      modelNotifier.value = modelNotifier.value.copyWith(isLoading: false);
    }
  }

  // Fetches report data for a specific week.
  Future<List<DailyReportData>> fetchWeeklyReport(DateTime date) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    // Determine the start and end of the week for the given date
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    final completionsSnapshot = await FirebaseFirestore.instance
        .collection('patients')
        .doc(user.uid)
        .collection('routine_completions')
        .where(
          'completedAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfWeek),
        )
        .where(
          'completedAt',
          isLessThanOrEqualTo: Timestamp.fromDate(endOfWeek),
        )
        .get();

    // Group completions by date
    final Map<String, List<QueryDocumentSnapshot>> completionsByDate = {};
    for (var doc in completionsSnapshot.docs) {
      final dateString = doc['completionDate'] as String;
      if (completionsByDate[dateString] == null) {
        completionsByDate[dateString] = [];
      }
      completionsByDate[dateString]!.add(doc);
    }

    // Generate daily data for the whole week
    final List<DailyReportData> weeklyData = [];
    for (int i = 0; i < 7; i++) {
      final day = startOfWeek.add(Duration(days: i));
      final dayString = DateFormat('yyyy-MM-dd').format(day);
      final dayCompletions = completionsByDate[dayString] ?? [];

      double netGlucose = 0;
      double totalProtein = 0;
      double totalCarbs = 0;
      double totalFat = 0;

      final completedTitles = dayCompletions
          .map((doc) => doc['levelTitle'] as String)
          .toSet();
      netGlucose = dayCompletions.fold(
        0.0,
        (sum, doc) => sum + (doc['glucoseImpact'] ?? 0.0),
      );

      // Calculate nutrition from master data
      for (var level in _routineData.levels) {
        if (completedTitles.contains(level.title)) {
          for (var task in level.subTasks) {
            totalProtein += task.protein ?? 0;
            totalCarbs += task.carbs ?? 0;
            totalFat += task.fat ?? 0;
          }
        }
      }

      weeklyData.add(
        DailyReportData(
          date: day,
          netGlucoseImpact: netGlucose,
          totalProtein: totalProtein,
          totalCarbs: totalCarbs,
          totalFat: totalFat,
        ),
      );
    }
    return weeklyData;
  }

  // Called when the user selects a new date from the calendar.
  Future<void> onDateSelected(DateTime newDate) async {
    modelNotifier.value = modelNotifier.value.copyWith(isLoading: true);
    final weeklyData = await fetchWeeklyReport(newDate);
    modelNotifier.value = modelNotifier.value.copyWith(
      weeklyReportData: weeklyData,
      isLoading: false,
    );
  }

  // Generates and triggers the download of a PDF report.
  Future<void> generateAndDownloadReport() async {
    final reportData = modelNotifier.value;
    if (reportData.weeklyReportData.isEmpty) return;

    final pdf = pw.Document();
    final font = await PdfGoogleFonts.poppinsRegular();
    final boldFont = await PdfGoogleFonts.poppinsBold();

    // Define start and end dates for the report title
    final startDate = reportData.weeklyReportData.first.date;
    final endDate = reportData.weeklyReportData.last.date;
    final reportDateRange =
        '${DateFormat.yMMMd().format(startDate)} - ${DateFormat.yMMMd().format(endDate)}';

    // Calculate weekly totals
    final weeklyTotalProtein = reportData.weeklyReportData.fold(
      0.0,
      (sum, day) => sum + day.totalProtein,
    );
    final weeklyTotalCarbs = reportData.weeklyReportData.fold(
      0.0,
      (sum, day) => sum + day.totalCarbs,
    );
    final weeklyTotalFat = reportData.weeklyReportData.fold(
      0.0,
      (sum, day) => sum + day.totalFat,
    );
    final weeklyAvgGlucose =
        reportData.weeklyReportData.fold(
          0.0,
          (sum, day) => sum + day.netGlucoseImpact,
        ) /
        7;

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Weekly Health Report',
              style: pw.TextStyle(font: boldFont, fontSize: 24),
            ),
            pw.Text(
              'Patient: ${reportData.patientName}',
              style: pw.TextStyle(font: font, fontSize: 16),
            ),
            pw.Text(
              'Report for: $reportDateRange',
              style: pw.TextStyle(font: font, fontSize: 16),
            ),
            // --- ERROR FIXED HERE ---
            // The Divider widget does not have a 'margin' property.
            // Wrapped it in a Padding widget to achieve the same spacing effect.
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 16),
              child: pw.Divider(),
            ),
            pw.Header(
              level: 2,
              text: 'Weekly Summary',
              textStyle: pw.TextStyle(font: boldFont, fontSize: 18),
            ),
            pw.Text(
              'Average Daily Glucose Impact: ${weeklyAvgGlucose.toStringAsFixed(1)} mg/dL',
              style: pw.TextStyle(font: font, fontSize: 12),
            ),
            pw.Text(
              'Total Protein: ${weeklyTotalProtein.toStringAsFixed(1)}g',
              style: pw.TextStyle(font: font, fontSize: 12),
            ),
            pw.Text(
              'Total Carbs: ${weeklyTotalCarbs.toStringAsFixed(1)}g',
              style: pw.TextStyle(font: font, fontSize: 12),
            ),
            pw.Text(
              'Total Fat: ${weeklyTotalFat.toStringAsFixed(1)}g',
              style: pw.TextStyle(font: font, fontSize: 12),
            ),
            pw.SizedBox(height: 24),
            pw.Header(
              level: 2,
              text: 'Daily Glucose Impact',
              textStyle: pw.TextStyle(font: boldFont, fontSize: 18),
            ),
            pw.Container(
              height: 200,
              child: pw.Chart(
                grid: pw.CartesianGrid(
                  xAxis: pw.FixedAxis(
                    List.generate(7, (index) => index.toDouble()),
                    format: (value) => DateFormat.E().format(
                      startDate.add(Duration(days: value.toInt())),
                    ),
                  ),
                  yAxis: pw.FixedAxis([
                    -20,
                    -10,
                    0,
                    10,
                    20,
                    30,
                    40,
                    50,
                  ], divisions: true),
                ),
                datasets: [
                  pw.BarDataSet(
                    data: reportData.weeklyReportData
                        .map(
                          (day) => pw.PointChartValue(
                            day.date.weekday - 1,
                            day.netGlucoseImpact,
                          ),
                        )
                        .toList(),
                    color: PdfColors.blue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // Save and open the PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // Signs the user out and navigates to the login screen.
  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
      (route) => false,
    );
  }

  void dispose() {
    modelNotifier.dispose();
  }
}

// COPIED from RoutineController to access master task data.
RoutineModel _getInitialRoutineData() {
  return RoutineModel(
    levels: [
      RoutineLevel(
        title: 'Level 1: Morning Rise',
        timeRange: '',
        icon: Icons.wb_sunny,
        subTasks: [
          SubTask(
            title: 'Warm Lemon Water',
            description: '',
            glucoseImpact: 0.5,
            instructions: [],
            rationale: '',
            protein: 0.1,
            carbs: 1.5,
            fat: 0,
          ),
          SubTask(
            title: 'Fenugreek Water',
            description: '',
            glucoseImpact: -1.0,
            instructions: [],
            rationale: '',
            protein: 1,
            carbs: 3,
            fat: 0.5,
          ),
          SubTask(
            title: 'Yoga for Diabetes',
            description: '',
            glucoseImpact: -5.0,
            instructions: [],
            rationale: '',
          ),
        ],
      ),
      RoutineLevel(
        title: 'Level 2: Balanced Breakfast',
        timeRange: '',
        icon: Icons.free_breakfast,
        subTasks: [
          SubTask(
            title: 'Vegetable Oats Upma',
            description: '',
            glucoseImpact: 15.0,
            instructions: [],
            rationale: '',
            protein: 8,
            carbs: 45,
            fat: 5,
          ),
        ],
      ),
      RoutineLevel(
        title: 'Level 3: Mid-Morning Snack',
        timeRange: '',
        icon: Icons.eco,
        subTasks: [
          SubTask(
            title: 'Handful of Almonds',
            description: '',
            glucoseImpact: 2.0,
            instructions: [],
            rationale: '',
            protein: 4,
            carbs: 4,
            fat: 9,
          ),
        ],
      ),
      RoutineLevel(
        title: 'Level 4: Mid-Day Fuel',
        timeRange: '',
        icon: Icons.restaurant,
        subTasks: [
          SubTask(
            title: 'Cucumber & Tomato Salad',
            description: '',
            glucoseImpact: 1.0,
            instructions: [],
            rationale: '',
            protein: 1,
            carbs: 5,
            fat: 0.2,
          ),
          SubTask(
            title: 'The Balanced Plate',
            description: '',
            glucoseImpact: 25.0,
            instructions: [],
            rationale: '',
            protein: 20,
            carbs: 60,
            fat: 12,
          ),
        ],
      ),
      RoutineLevel(
        title: 'Level 5: Afternoon Recharge',
        timeRange: '',
        icon: Icons.self_improvement,
        subTasks: [
          SubTask(
            title: 'Spiced Buttermilk (Chaas)',
            description: '',
            glucoseImpact: 3.0,
            instructions: [],
            rationale: '',
            protein: 3,
            carbs: 4,
            fat: 2.5,
          ),
          SubTask(
            title: '5-Minute Desk Stretch',
            description: '',
            glucoseImpact: -1.0,
            instructions: [],
            rationale: '',
          ),
        ],
      ),
      RoutineLevel(
        title: 'Level 6: Evening Wind-Down',
        timeRange: '',
        icon: Icons.dinner_dining,
        subTasks: [
          SubTask(
            title: 'Paneer & Veggie Stir-fry',
            description: '',
            glucoseImpact: 8.0,
            instructions: [],
            rationale: '',
            protein: 12,
            carbs: 8,
            fat: 15,
          ),
          SubTask(
            title: 'Gentle Stroll',
            description: '',
            glucoseImpact: -4.0,
            instructions: [],
            rationale: '',
          ),
        ],
      ),
      RoutineLevel(
        title: 'Level 7: Bedtime Preparation',
        timeRange: '',
        icon: Icons.bedtime,
        subTasks: [
          SubTask(
            title: 'Cinnamon & Turmeric Milk',
            description: '',
            glucoseImpact: -1.0,
            instructions: [],
            rationale: '',
            protein: 5,
            carbs: 8,
            fat: 3,
          ),
          SubTask(
            title: 'Daily Foot Check',
            description: '',
            glucoseImpact: 0.0,
            instructions: [],
            rationale: '',
          ),
        ],
      ),
    ],
  );
}
