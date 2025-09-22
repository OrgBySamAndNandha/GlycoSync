import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../controller/profile_controller.dart';
import '../model/profile_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final ProfileController _controller;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _controller = ProfileController();
    _controller.fetchProfileData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Function to show the date picker and fetch new data
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _controller.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: ValueListenableBuilder<ProfileModel>(
        valueListenable: _controller.modelNotifier,
        builder: (context, model, child) {
          if (model.isLoading && model.patientName == 'Loading...') {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProfileHeader(context, model),
                const SizedBox(height: 24),
                _buildHealthSnapshot(context, model),
                const SizedBox(height: 24),
                _buildWeeklyReport(context, model),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, ProfileModel model) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              child: Icon(Icons.person, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.patientName,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(model.patientEmail,
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.red),
              onPressed: () => _controller.signOut(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthSnapshot(BuildContext context, ProfileModel model) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Health Snapshot',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Diabetes Type', model.diabetesType),
                _buildStatItem('Height', '${model.height} cm'),
                _buildStatItem('Weight', '${model.weight} kg'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildWeeklyReport(BuildContext context, ProfileModel model) {
    // Calculate weekly totals from the model
    final weeklyTotalProtein =
        model.weeklyReportData.fold(0.0, (sum, day) => sum + day.totalProtein);
    final weeklyTotalCarbs =
        model.weeklyReportData.fold(0.0, (sum, day) => sum + day.totalCarbs);
    final weeklyTotalFat =
        model.weeklyReportData.fold(0.0, (sum, day) => sum + day.totalFat);
    final weeklyAvgGlucose = model.weeklyReportData
            .fold(0.0, (sum, day) => sum + day.netGlucoseImpact) /
        (model.weeklyReportData.isEmpty ? 1 : model.weeklyReportData.length);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weekly Report',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: Text(DateFormat.yMMMd().format(_selectedDate)),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (model.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (model.weeklyReportData.isEmpty)
              const Center(child: Text('No data for this week.'))
            else
              Column(
                children: [
                  _buildStatItem(
                      'Avg. Glucose Impact',
                      '${weeklyAvgGlucose.toStringAsFixed(1)} mg/dL'),
                  const Divider(height: 24),
                  SizedBox(
                    height: 200,
                    child: BarChart(_buildBarChartData(model.weeklyReportData)),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.download),
                    label: const Text('Download Report'),
                    onPressed: () {
                      _controller.generateAndDownloadReport();
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  BarChartData _buildBarChartData(List<DailyReportData> data) {
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: 50, // Adjust based on expected data range
      minY: -20,
      barTouchData: BarTouchData(enabled: false),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              final day = data[value.toInt()].date;
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(DateFormat.E().format(day)), // e.g., 'Mon'
              );
            },
            reservedSize: 30,
          ),
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 10,
        getDrawingHorizontalLine: (value) => FlLine(
          color: Colors.grey.withOpacity(0.2),
          strokeWidth: 1,
        ),
      ),
      borderData: FlBorderData(show: false),
      barGroups: data
          .asMap()
          .entries
          .map(
            (entry) => BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value.netGlucoseImpact,
                  color: entry.value.netGlucoseImpact >= 0
                      ? Colors.orange
                      : Colors.blue,
                  width: 16,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                )
              ],
            ),
          )
          .toList(),
    );
  }
}
