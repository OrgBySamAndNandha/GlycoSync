import 'package:flutter/material.dart';
import 'package:glycosync/screens/Patients/community_chat/view/community_chat_view.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controller/home_controller.dart';
import '../model/home_model.dart';
// Import the new empowerment view
import 'package:glycosync/screens/Patients/empowerment/view/empowerment_view.dart';

class HomeView extends StatefulWidget {
  // MODIFIED: Added a key to the constructor
  const HomeView({super.key});

  @override
  State<HomeView> createState() => HomeViewState();
}

enum AnalyticsCategory { glucose, nutrition }

// MODIFIED: Renamed state class to be public
class HomeViewState extends State<HomeView> {
  late final HomeController _controller;
  // State for the segmented button
  AnalyticsCategory _selectedCategory = AnalyticsCategory.glucose;

  @override
  void initState() {
    super.initState();
    _controller = HomeController();
    _controller.loadHomeData();
  }

  // --- NEW: Public method to refresh the data ---
  // This method will be called by the navigation bar.
  void refreshData() {
    _controller.loadHomeData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF5EFE6,
      ), // Your very light cream background
      appBar: AppBar(
        title: const Text(
          'GlycoSync',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(
          0xFF6D94C5,
        ), // Your medium blue - solid color
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.self_improvement_outlined,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EmpowermentView()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CommunityChatView(),
                ),
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<HomeModel>(
        valueListenable: _controller.modelNotifier,
        builder: (context, model, child) {
          return SafeArea(
            top: false, // AppBar handles the top safe area
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAnalyticsCard(context, model),
                  const SizedBox(height: 24),
                  _buildCalendarCard(context, model),
                  const SizedBox(height: 24),
                  _buildTasksCard(context, model),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnalyticsCard(BuildContext context, HomeModel model) {
    // Determine if there is any nutritional data to show
    final bool hasNutritionData =
        (model.totalProtein + model.totalCarbs + model.totalFat) > 0;

    return _buildSectionCard(
      context: context,
      title: "Today's Analytics",
      icon: Icons.bar_chart,
      child: Column(
        children: [
          SegmentedButton<AnalyticsCategory>(
            segments: const [
              ButtonSegment(
                value: AnalyticsCategory.glucose,
                label: Text('Glucose'),
              ),
              ButtonSegment(
                value: AnalyticsCategory.nutrition,
                label: Text('Nutrition'),
              ),
            ],
            selected: {_selectedCategory},
            onSelectionChanged: (newSelection) {
              setState(() {
                _selectedCategory = newSelection.first;
              });
            },
            style: SegmentedButton.styleFrom(
              backgroundColor: const Color(
                0xFFCBDCEB,
              ), // Your light blue - more professional
              selectedBackgroundColor: const Color(
                0xFF6D94C5,
              ), // Your medium blue
              selectedForegroundColor: Colors.white,
              foregroundColor: const Color(0xFF6D94C5), // Your medium blue
              side: BorderSide.none,
            ),
          ),
          const SizedBox(height: 24),
          // Conditional content based on the selected category
          if (_selectedCategory == AnalyticsCategory.glucose)
            Text(
              model.analyticsSummary,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            )
          else if (hasNutritionData)
            SizedBox(
              height: 180,
              child: PieChart(_buildPieChartData(context, model)),
            )
          else
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'No nutritional data recorded for today.',
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  PieChartData _buildPieChartData(BuildContext context, HomeModel model) {
    final totalNutrients =
        model.totalProtein + model.totalCarbs + model.totalFat;
    if (totalNutrients == 0) return PieChartData(sections: []);

    return PieChartData(
      sectionsSpace: 2,
      centerSpaceRadius: 40,
      sections: [
        PieChartSectionData(
          color: const Color(0xFF6D94C5), // Your medium blue for protein
          value: model.totalProtein,
          title:
              '${((model.totalProtein / totalNutrients) * 100).toStringAsFixed(0)}%\nProtein',
          radius: 55,
          titleStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        PieChartSectionData(
          color: const Color(0xFFCBDCEB), // Your light blue for carbs
          value: model.totalCarbs,
          title:
              '${((model.totalCarbs / totalNutrients) * 100).toStringAsFixed(0)}%\nCarbs',
          radius: 55,
          titleStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6D94C5), // Darker text for light background
          ),
        ),
        PieChartSectionData(
          color: const Color(0xFFE8DFCA), // Your beige for fat
          value: model.totalFat,
          title:
              '${((model.totalFat / totalNutrients) * 100).toStringAsFixed(0)}%\nFat',
          radius: 55,
          titleStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6D94C5), // Darker text for light background
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarCard(BuildContext context, HomeModel model) {
    return _buildSectionCard(
      context: context,
      title: 'Calendar',
      icon: Icons.calendar_today,
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: model.selectedDate,
        selectedDayPredicate: (day) => isSameDay(model.selectedDate, day),
        onDaySelected: (selectedDay, focusedDay) {
          _controller.onDateSelected(selectedDay);
        },
        calendarStyle: CalendarStyle(
          todayDecoration: const BoxDecoration(
            color: Color(0xFFCBDCEB), // Your light blue
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: Color(0xFF6D94C5), // Your medium blue
            shape: BoxShape.circle,
          ),
        ),
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: Theme.of(
            context,
          ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTasksCard(BuildContext context, HomeModel model) {
    return _buildSectionCard(
      context: context,
      title:
          'Completed Levels for ${DateFormat.yMMMd().format(model.selectedDate)}',
      icon: Icons.list_alt,
      child: model.dailyTasks.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text('No completed levels for this day.'),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: model.dailyTasks.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white, // White background for contrast
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFCBDCEB),
                    ), // Your light blue border
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFF6D94C5), // Your medium blue
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    title: Text(
                      model.dailyTasks[index],
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6D94C5), // Your medium blue text
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFCBDCEB), // Your light blue - solid shadow
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFF6D94C5,
                    ), // Your medium blue - solid color
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6D94C5), // Your medium blue text
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(vertical: 16),
              decoration: const BoxDecoration(
                color: Color(0xFFCBDCEB), // Your light blue - solid color
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
