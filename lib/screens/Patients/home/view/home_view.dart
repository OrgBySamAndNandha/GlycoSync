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
      appBar: AppBar(
        title: const Text(
          'GlycoSync',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.self_improvement_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EmpowermentView()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
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
              backgroundColor: Colors.grey.shade200,
              selectedBackgroundColor: Theme.of(context).primaryColor,
              selectedForegroundColor: Colors.white,
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
          color: Colors.blue.shade400,
          value: model.totalProtein,
          title:
              '${((model.totalProtein / totalNutrients) * 100).toStringAsFixed(0)}%\nProtein',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        PieChartSectionData(
          color: Colors.orange.shade400,
          value: model.totalCarbs,
          title:
              '${((model.totalCarbs / totalNutrients) * 100).toStringAsFixed(0)}%\nCarbs',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        PieChartSectionData(
          color: Colors.red.shade400,
          value: model.totalFat,
          title:
              '${((model.totalFat / totalNutrients) * 100).toStringAsFixed(0)}%\nFat',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
          todayDecoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
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
                return ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: Text(model.dailyTasks[index]),
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
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 1),
            child,
          ],
        ),
      ),
    );
  }
}
