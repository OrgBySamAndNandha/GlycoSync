import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controller/home_controller.dart';
import '../model/home_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

// --- NEW: Enum to manage the state of the analytics card view ---
enum _AnalyticsCardView { glucose, nutrition }

class _HomeViewState extends State<HomeView> {
  late final HomeController _controller;
  // --- NEW: State variable to track the selected view ---
  _AnalyticsCardView _currentAnalyticsView = _AnalyticsCardView.glucose;

  @override
  void initState() {
    super.initState();
    _controller = HomeController();
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
      body: ValueListenableBuilder<HomeModel>(
        valueListenable: _controller.modelNotifier,
        builder: (context, model, child) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.welcomeMessage,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
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

  // --- WIDGET MODIFIED: To show selectable views for Glucose and Nutrition ---
  Widget _buildAnalyticsCard(BuildContext context, HomeModel model) {
    final double totalGrams =
        model.totalProtein + model.totalCarbs + model.totalFat;
    final bool hasData = totalGrams > 0;

    return _buildSectionCard(
      context: context,
      title: "Today's Analytics",
      icon: Icons.analytics_outlined,
      child: Column(
        children: [
          // --- NEW: Segmented button to switch between views ---
          SegmentedButton<_AnalyticsCardView>(
            segments: const [
              ButtonSegment(
                value: _AnalyticsCardView.glucose,
                label: Text('Glucose'),
              ),
              ButtonSegment(
                value: _AnalyticsCardView.nutrition,
                label: Text('Nutrition'),
              ),
            ],
            selected: {_currentAnalyticsView},
            onSelectionChanged: (newSelection) {
              setState(() {
                _currentAnalyticsView = newSelection.first;
              });
            },
            style: SegmentedButton.styleFrom(
              backgroundColor: Colors.grey.shade200,
              selectedBackgroundColor: Theme.of(context).primaryColor,
              selectedForegroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 24),

          // --- NEW: AnimatedSwitcher for a smooth transition between views ---
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _currentAnalyticsView == _AnalyticsCardView.glucose
                // --- GLUCOSE VIEW ---
                ? Container(
                    key: const ValueKey('glucose_view'),
                    height: 150, // Set a fixed height to prevent layout jumps
                    alignment: Alignment.center,
                    child: Text(
                      model.analyticsSummary,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  )
                // --- NUTRITION VIEW ---
                : Container(
                    key: const ValueKey('nutrition_view'),
                    height: 150, // Match the height for a smooth transition
                    child: hasData
                        ? Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: PieChart(
                                  PieChartData(
                                    sections: _buildPieChartSections(
                                      model,
                                      totalGrams,
                                    ),
                                    centerSpaceRadius: 40,
                                    sectionsSpace: 2,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLegendItem(
                                      color: Colors.blue.shade400,
                                      text:
                                          'Protein (${model.totalProtein.toStringAsFixed(1)}g)',
                                    ),
                                    const SizedBox(height: 8),
                                    _buildLegendItem(
                                      color: Colors.orange.shade400,
                                      text:
                                          'Carbs (${model.totalCarbs.toStringAsFixed(1)}g)',
                                    ),
                                    const SizedBox(height: 8),
                                    _buildLegendItem(
                                      color: Colors.red.shade400,
                                      text:
                                          'Fat (${model.totalFat.toStringAsFixed(1)}g)',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : const Center(
                            child: Text(
                              'Complete a routine to see nutrition details.',
                            ),
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  // Helper method to build pie chart sections (no changes needed)
  List<PieChartSectionData> _buildPieChartSections(
    HomeModel model,
    double totalGrams,
  ) {
    if (totalGrams == 0) return [];

    final double proteinPercentage = (model.totalProtein / totalGrams) * 100;
    final double carbsPercentage = (model.totalCarbs / totalGrams) * 100;
    final double fatPercentage = (model.totalFat / totalGrams) * 100;

    return [
      PieChartSectionData(
        value: model.totalProtein,
        title: '${proteinPercentage.toStringAsFixed(0)}%',
        color: Colors.blue.shade400,
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: model.totalCarbs,
        title: '${carbsPercentage.toStringAsFixed(0)}%',
        color: Colors.orange.shade400,
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: model.totalFat,
        title: '${fatPercentage.toStringAsFixed(0)}%',
        color: Colors.red.shade400,
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  // Helper widget for the pie chart legend (no changes needed)
  Widget _buildLegendItem({required Color color, required String text}) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 8),
        Expanded(child: Text(text, overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  // Widget for the Calendar Card (no changes needed)
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

  // Widget for the Daily Tasks Card (no changes needed)
  Widget _buildTasksCard(BuildContext context, HomeModel model) {
    return _buildSectionCard(
      context: context,
      title:
          'Completed Levels for ${DateFormat.yMMMd().format(model.selectedDate)}',
      icon: Icons.list_alt,
      child: model.dailyTasks.isEmpty
          ? const Center(child: Text('No completed levels for this day.'))
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

  // Helper widget for card styling (no changes needed)
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
