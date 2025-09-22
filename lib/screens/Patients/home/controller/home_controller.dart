import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:glycosync/screens/Patients/routine/model/routine_model.dart'; // Import RoutineModel
import '../model/home_model.dart';

class HomeController {
  final ValueNotifier<HomeModel> modelNotifier;

  HomeController()
    : modelNotifier = ValueNotifier(HomeModel(selectedDate: DateTime.now()));

  void loadHomeData() {
    _updateAnalyticsForSelectedDate();
  }

  void onDateSelected(DateTime newDate) {
    // Update the date in the model and re-fetch data for that new date.
    modelNotifier.value = modelNotifier.value.copyWith(selectedDate: newDate);
    _updateAnalyticsForSelectedDate();
  }

  // Simplified method to fetch data for the currently selected date.
  Future<void> _updateAnalyticsForSelectedDate() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final selectedDate = modelNotifier.value.selectedDate;

    // Set loading state
    modelNotifier.value = modelNotifier.value.copyWith(
      analyticsSummary: 'Loading...',
      dailyTasks: [],
      totalProtein: 0,
      totalCarbs: 0,
      totalFat: 0,
    );

    try {
      final query = FirebaseFirestore.instance
          .collection('patients')
          .doc(user.uid)
          .collection('routine_completions');

      await _generateDayAnalytics(query, selectedDate);
    } catch (e) {
      modelNotifier.value = modelNotifier.value.copyWith(
        analyticsSummary: 'Error loading data.',
      );
    }
  }

  // --- MODIFIED: This method now also calculates total nutrition ---
  Future<void> _generateDayAnalytics(Query query, DateTime date) async {
    final dateString = DateFormat('yyyy-MM-dd').format(date);
    final snapshot = await query
        .where('completionDate', isEqualTo: dateString)
        .get();

    double totalGlucoseImpact = 0;
    List<String> completedTaskTitles = [];

    // --- NEW: Nutrition calculation variables ---
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;

    if (snapshot.docs.isNotEmpty) {
      // Get the master list of all possible routine tasks to find their nutritional info
      final masterRoutine = _getInitialRoutineData();
      final completedLevelTitles = snapshot.docs
          .map((doc) => doc['levelTitle'] as String)
          .toSet();

      for (var doc in snapshot.docs) {
        totalGlucoseImpact += doc['glucoseImpact'] ?? 0;
        completedTaskTitles.add(doc['levelTitle'] ?? 'Completed Task');
      }

      // --- NEW: Loop through master routine to find completed tasks and sum nutrition ---
      for (var level in masterRoutine.levels) {
        if (completedLevelTitles.contains(level.title)) {
          for (var task in level.subTasks) {
            totalProtein += task.protein ?? 0;
            totalCarbs += task.carbs ?? 0;
            totalFat += task.fat ?? 0;
          }
        }
      }

      String summary;
      if (totalGlucoseImpact > 0.1) {
        summary =
            "Today's net glucose impact is an estimated increase of ${totalGlucoseImpact.toStringAsFixed(1)} mg/dL.";
      } else if (totalGlucoseImpact < -0.1) {
        summary =
            "Today's net glucose impact is an estimated decrease of ${(-totalGlucoseImpact).toStringAsFixed(1)} mg/dL.";
      } else {
        summary = "Today's net glucose impact is estimated to be neutral.";
      }

      modelNotifier.value = modelNotifier.value.copyWith(
        analyticsSummary: summary,
        dailyTasks: completedTaskTitles,
        totalProtein: totalProtein,
        totalCarbs: totalCarbs,
        totalFat: totalFat,
      );
    } else {
      modelNotifier.value = modelNotifier.value.copyWith(
        analyticsSummary: 'No routine data recorded for this day.',
        dailyTasks: [],
        totalProtein: 0,
        totalCarbs: 0,
        totalFat: 0,
      );
    }
  }

  void dispose() {
    modelNotifier.dispose();
  }

  // --- COPIED from RoutineController ---
  // This is needed to access the nutritional data of all possible tasks.
  RoutineModel _getInitialRoutineData() {
    return RoutineModel(
      levels: [
        RoutineLevel(
          title: 'Level 1: Morning Rise',
          timeRange: '6:00 AM - 9:00 AM',
          icon: Icons.wb_sunny_outlined,
          subTasks: [
            SubTask(
              title: 'Warm Lemon Water',
              description: 'Kickstart your metabolism and hydrate.',
              glucoseImpact: 0.5,
              instructions: [],
              rationale: '',
              calories: 5,
              protein: 0.1,
              carbs: 1.5,
              fat: 0,
            ),
            SubTask(
              title: 'Fenugreek Water',
              description: 'A traditional remedy for blood sugar regulation.',
              glucoseImpact: -1.0,
              instructions: [],
              rationale: '',
              calories: 15,
              protein: 1,
              carbs: 3,
              fat: 0.5,
            ),
            SubTask(
              title: 'Yoga for Diabetes',
              description:
                  'A 20-minute session to improve insulin sensitivity.',
              glucoseImpact: -5.0,
              instructions: [],
              rationale: '',
            ),
          ],
        ),
        RoutineLevel(
          title: 'Level 2: Balanced Breakfast',
          timeRange: '8:30 AM - 9:30 AM',
          icon: Icons.free_breakfast,
          subTasks: [
            SubTask(
              title: 'Vegetable Oats Upma',
              description: 'A fiber-rich breakfast for sustained energy.',
              glucoseImpact: 15.0,
              instructions: [],
              rationale: '',
              calories: 250,
              protein: 8,
              carbs: 45,
              fat: 5,
            ),
          ],
        ),
        RoutineLevel(
          title: 'Level 3: Mid-Morning Snack',
          timeRange: '11:00 AM - 11:30 AM',
          icon: Icons.eco,
          subTasks: [
            SubTask(
              title: 'Handful of Almonds',
              description: 'A nutrient-dense snack to prevent hunger.',
              glucoseImpact: 2.0,
              instructions: [],
              rationale: '',
              calories: 100,
              protein: 4,
              carbs: 4,
              fat: 9,
            ),
          ],
        ),
        RoutineLevel(
          title: 'Level 4: Mid-Day Fuel',
          timeRange: '12:30 PM - 2:00 PM',
          icon: Icons.restaurant_menu,
          subTasks: [
            SubTask(
              title: 'Cucumber & Tomato Salad',
              description: 'A pre-lunch salad to slow sugar absorption.',
              glucoseImpact: 1.0,
              instructions: [],
              rationale: '',
              calories: 25,
              protein: 1,
              carbs: 5,
              fat: 0.2,
            ),
            SubTask(
              title: 'The Balanced Plate',
              description: 'A wholesome meal with a good mix of nutrients.',
              glucoseImpact: 25.0,
              instructions: [],
              rationale: '',
              calories: 450,
              protein: 20,
              carbs: 60,
              fat: 12,
            ),
          ],
        ),
        RoutineLevel(
          title: 'Level 5: Afternoon Recharge',
          timeRange: '4:00 PM - 4:30 PM',
          icon: Icons.self_improvement,
          subTasks: [
            SubTask(
              title: 'Spiced Buttermilk (Chaas)',
              description: 'A refreshing, probiotic-rich drink.',
              glucoseImpact: 3.0,
              instructions: [],
              rationale: '',
              calories: 50,
              protein: 3,
              carbs: 4,
              fat: 2.5,
            ),
            SubTask(
              title: '5-Minute Desk Stretch',
              description: 'Relieve stiffness and improve blood flow.',
              glucoseImpact: -1.0,
              instructions: [],
              rationale: '',
            ),
          ],
        ),
        RoutineLevel(
          title: 'Level 6: Evening Wind-Down',
          timeRange: '7:00 PM - 8:30 PM',
          icon: Icons.dinner_dining,
          subTasks: [
            SubTask(
              title: 'Paneer & Veggie Stir-fry',
              description: 'A light, protein-packed dinner.',
              glucoseImpact: 8.0,
              instructions: [],
              rationale: '',
              calories: 220,
              protein: 12,
              carbs: 8,
              fat: 15,
            ),
            SubTask(
              title: 'Gentle Stroll',
              description: 'A 15-minute slow and steady walk after dinner.',
              glucoseImpact: -4.0,
              instructions: [],
              rationale: '',
            ),
          ],
        ),
        RoutineLevel(
          title: 'Level 7: Bedtime Preparation',
          timeRange: '9:30 PM - 10:00 PM',
          icon: Icons.bedtime,
          subTasks: [
            SubTask(
              title: 'Cinnamon & Turmeric Milk',
              description: 'A warm, soothing drink to help you relax.',
              glucoseImpact: -1.0,
              instructions: [],
              rationale: '',
              calories: 80,
              protein: 5,
              carbs: 8,
              fat: 3,
            ),
            SubTask(
              title: 'Daily Foot Check',
              description: 'An essential daily habit to prevent complications.',
              glucoseImpact: 0.0,
              instructions: [],
              rationale: '',
            ),
          ],
        ),
      ],
    );
  }
}
