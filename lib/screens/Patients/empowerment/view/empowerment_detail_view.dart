import 'package:flutter/material.dart';
import '../model/empowerment_model.dart';

class EmpowermentDetailView extends StatelessWidget {
  final EmpowermentContent content;

  const EmpowermentDetailView({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(content.title),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display GIF for workouts
            if (content.type == ContentType.workout &&
                content.gifPath != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(content.gifPath!),
                ),
              ),

            // Section Title for Instructions or Document
            Text(
              content.type == ContentType.workout
                  ? 'Instructions'
                  : 'Information',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(height: 20),

            // Display instructions for workouts
            if (content.type == ContentType.workout)
              ...content.instructions
                  .map((item) => _buildListItem(context, item)),

            // Display detailed document for Ayurveda articles
            if (content.type == ContentType.ayurveda &&
                content.detailedDoc != null)
              Text(
                content.detailedDoc!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
              ),
          ],
        ),
      ),
    );
  }

  // Helper widget for list items (for instructions)
  Widget _buildListItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline,
              color: Theme.of(context).primaryColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
              child: Text(text,
                  style: Theme.of(context).textTheme.bodyLarge)),
        ],
      ),
    );
  }
}
