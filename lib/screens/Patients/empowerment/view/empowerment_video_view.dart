import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../model/empowerment_model.dart';

class EmpowermentVideoView extends StatefulWidget {
  final EmpowermentContent content;

  const EmpowermentVideoView({super.key, required this.content});

  @override
  State<EmpowermentVideoView> createState() => _EmpowermentVideoViewState();
}

class _EmpowermentVideoViewState extends State<EmpowermentVideoView> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.content.youtubeVideoId ?? '',
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(controller: _controller),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.content.title),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // YouTube Player Widget
                player,

                // --- NEW: Redesigned Content Section ---
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.content.title,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),

                      // --- NEW: Info Chips for Difficulty and Duration ---
                      Row(
                        children: [
                          if (widget.content.difficulty != null)
                            _buildInfoChip(
                              icon: Icons.bar_chart,
                              label: widget.content.difficulty!,
                              color: Colors.orange,
                            ),
                          const SizedBox(width: 12),
                          if (widget.content.duration != null)
                            _buildInfoChip(
                              icon: Icons.timer_outlined,
                              label: widget.content.duration!,
                              color: Colors.blue,
                            ),
                        ],
                      ),

                      const Divider(height: 40),

                      // --- NEW: Key Benefits Section ---
                      _buildSectionTitle(context, 'Key Focus Areas'),
                      if (widget.content.benefits != null)
                        ...widget.content.benefits!
                            .map((benefit) => _buildBenefitTile(benefit))
                            .toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper widget for section titles
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  // Helper widget for displaying info chips (Difficulty, Duration)
  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Chip(
      avatar: Icon(icon, color: color, size: 20),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: color.withOpacity(0.2)),
      ),
    );
  }

  // Helper widget for displaying a key benefit
  Widget _buildBenefitTile(KeyBenefit benefit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            color: Colors.green.shade600,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  benefit.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  benefit.description,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
