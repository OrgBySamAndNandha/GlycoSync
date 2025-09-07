import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../controller/home_controller.dart';
import '../model/home_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeController _controller;

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

                  // --- UPDATED ANALYTICS CARD ---
                  _buildAnalyticsCard(context, model),
                  const SizedBox(height: 24),

                  // --- CALENDAR CARD ---
                  _buildCalendarCard(context, model),
                  const SizedBox(height: 24),

                  // --- NEW ROUTINE/TASKS CARD ---
                  // This card only shows when in the "Day" view
                  if (model.currentViewType == AnalyticsViewType.day)
                    _buildTasksCard(context, model),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget for the Analytics Card with segmented buttons
  Widget _buildAnalyticsCard(BuildContext context, HomeModel model) {
    return _buildSectionCard(
      context: context,
      title: 'Analytics',
      icon: Icons.bar_chart,
      child: Column(
        children: [
          SegmentedButton<AnalyticsViewType>(
            segments: const [
              ButtonSegment(value: AnalyticsViewType.day, label: Text('Day')),
              ButtonSegment(
                value: AnalyticsViewType.month,
                label: Text('Month'),
              ),
              ButtonSegment(value: AnalyticsViewType.year, label: Text('Year')),
            ],
            selected: {model.currentViewType},
            onSelectionChanged: (newSelection) {
              _controller.changeViewType(newSelection.first);
            },
            style: SegmentedButton.styleFrom(
              backgroundColor: Colors.grey.shade200,
              selectedBackgroundColor: Theme.of(context).primaryColor,
              selectedForegroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            model.analyticsSummary,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Widget for the Calendar Card
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

  // NEW: Widget for the Daily Tasks Card
  Widget _buildTasksCard(BuildContext context, HomeModel model) {
    return _buildSectionCard(
      context: context,
      title: 'Routine for ${DateFormat.yMMMd().format(model.selectedDate)}',
      icon: Icons.list_alt,
      child: model.dailyTasks.isEmpty
          ? const Center(child: Text('No tasks for today.'))
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: model.dailyTasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                  ),
                  title: Text(model.dailyTasks[index]),
                );
              },
            ),
    );
  }

  // Helper widget to create the styled cards for each section.
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
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
