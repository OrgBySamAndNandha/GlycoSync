import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controller/lab_report_submission_controller.dart';
import '../model/lab_report_model.dart';

class LabReportSubmissionView extends StatefulWidget {
  const LabReportSubmissionView({super.key});

  @override
  State<LabReportSubmissionView> createState() =>
      _LabReportSubmissionViewState();
}

class _LabReportSubmissionViewState extends State<LabReportSubmissionView> {
  late final LabReportSubmissionController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = LabReportSubmissionController();
    _controller.fetchSubmissionHistory();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _controller.submitReport(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6), // Your cream background
      appBar: AppBar(
        title: const Text(
          'Submit Lab Report',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFF6D94C5), // Your medium blue
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSubmissionForm(),
            const SizedBox(height: 32),
            _buildSubmissionHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmissionForm() {
    return Form(
      key: _formKey,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter New Results',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6D94C5), // Your medium blue
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _controller.hba1cController,
                decoration: const InputDecoration(
                  labelText: 'HbA1c (%)',
                  labelStyle: TextStyle(
                    color: Color(0xFF6D94C5),
                  ), // Your medium blue
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF6D94C5),
                    ), // Your medium blue
                  ),
                ),
                style: const TextStyle(
                  color: Color(0xFF6D94C5),
                ), // Your medium blue
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a value'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _controller.fastingSugarController,
                decoration: const InputDecoration(
                  labelText: 'Fasting Blood Sugar (mg/dL)',
                  labelStyle: TextStyle(
                    color: Color(0xFF6D94C5),
                  ), // Your medium blue
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF6D94C5),
                    ), // Your medium blue
                  ),
                ),
                style: const TextStyle(
                  color: Color(0xFF6D94C5),
                ), // Your medium blue
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a value'
                    : null,
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<DateTime>(
                valueListenable: _controller.selectedDateNotifier,
                builder: (context, selectedDate, child) {
                  return OutlinedButton.icon(
                    icon: const Icon(
                      Icons.calendar_today,
                      color: Color(0xFF6D94C5), // Your medium blue
                    ),
                    label: Text(
                      'Report Date: ${DateFormat.yMMMd().format(selectedDate)}',
                      style: const TextStyle(
                        color: Color(0xFF6D94C5), // Your medium blue
                      ),
                    ),
                    onPressed: () => _controller.selectDate(context),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      side: const BorderSide(
                        color: Color(0xFF6D94C5),
                      ), // Your medium blue
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color(0xFF6D94C5), // Your medium blue
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Submit Report',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmissionHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Submission History',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6D94C5), // Your medium blue
          ),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<List<LabReportSubmission>>(
          valueListenable: _controller.historyNotifier,
          builder: (context, history, child) {
            if (history.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text('No previous submissions found.'),
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final report = history[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      'Report from ${DateFormat.yMMMd().format(report.reportDate)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6D94C5), // Your medium blue
                      ),
                    ),
                    subtitle: Text(
                      'HbA1c: ${report.hba1c}%  •  Avg. Glucose: ${report.avgBloodGlucose} mg/dL',
                      style: const TextStyle(
                        color: Color(0xFF6D94C5), // Your medium blue
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
