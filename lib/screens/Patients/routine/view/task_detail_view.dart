import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6D94C5), // Your medium blue
              ),
            ),
            const SizedBox(height: 8),
            // Description
            Text(
              task.description,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF6D94C5), // Your medium blue
              ),
            ),
            const Divider(height: 32),

            // Animation if available
            if (task.gifPath != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFFF5EFE6), // Your cream background
                  ),
                  child: Lottie.asset(
                    task.gifPath!,
                    fit: BoxFit.contain,
                    repeat: true,
                    animate: true,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.animation,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
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
            Text(
              task.rationale,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6D94C5), // Your medium blue
              ),
            ),
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
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF6D94C5), // Your medium blue
        ),
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
          const Text(
            '• ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF6D94C5), // Your medium blue
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF6D94C5), // Your medium blue
              ),
            ),
          ),
        ],
      ),
    );
  }
}
