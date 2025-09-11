import 'package:flutter/material.dart';
import '../model/routine_model.dart';

class TaskDetailView extends StatelessWidget {
  final SubTask task;

  const TaskDetailView({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    // Wrap with a container to constrain the height in the bottom sheet
    return Container(
      // Allow it to take up to 80% of the screen height
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              task.title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Description
            Text(
              task.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Divider(height: 32),

            // GIF if available
            if (task.gifPath != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(task.gifPath!),
                ),
              ),

            // Ingredients if available
            if (task.ingredients != null && task.ingredients!.isNotEmpty) ...[
              _buildSectionTitle(context, 'Ingredients'),
              ...task.ingredients!.map((item) => _buildListItem(context, item)),
              const SizedBox(height: 16),
            ],

            // Instructions
            _buildSectionTitle(context, 'Instructions'),
            ...task.instructions.map((item) => _buildListItem(context, item)),
            const SizedBox(height: 16),

            // Rationale
            _buildSectionTitle(context, 'Why This Helps'),
            Text(task.rationale, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  // Helper widget for section titles
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  // Helper widget for list items (for ingredients/instructions)
  Widget _buildListItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0, left: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
