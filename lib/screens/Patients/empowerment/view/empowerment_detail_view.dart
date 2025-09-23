import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/empowerment_model.dart';

class EmpowermentDetailView extends StatelessWidget {
  final EmpowermentContent content;

  const EmpowermentDetailView({super.key, required this.content});

  // Helper function to launch URLs in an external browser
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // Could not launch the URL, handle error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(content.title),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the main image for the article
            if (content.imagePath != null)
              Image.asset(
                content.imagePath!,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Article Title
                  Text(
                    content.title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  // Article Description
                  Text(
                    content.description,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.black54, fontStyle: FontStyle.italic),
                  ),
                  const Divider(height: 40),

                  // Key Benefits Section
                  _buildSectionTitle(context, 'Key Benefits'),
                  if (content.benefits != null)
                    ...content.benefits!
                        .map((benefit) => _buildBenefitTile(benefit))
                        .toList(),

                  const SizedBox(height: 30),

                  // How to Use Section
                  _buildSectionTitle(context, 'How to Use'),
                  if (content.howToUse != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Text(
                        content.howToUse!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(height: 1.5, color: Colors.black87),
                      ),
                    ),

                  const SizedBox(height: 30),

                  // Link to Scientific Source for credibility
                  if (content.sourceUrl != null)
                    Center(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.link),
                        label: const Text('View Scientific Proof'),
                        onPressed: () => _launchURL(content.sourceUrl!),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for styling section titles
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  // Helper widget for displaying a key benefit with an icon
  Widget _buildBenefitTile(KeyBenefit benefit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline,
              color: Colors.green, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(benefit.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(benefit.description,
                    style: const TextStyle(
                        fontSize: 14, height: 1.4, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

