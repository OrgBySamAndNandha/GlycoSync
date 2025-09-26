import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:video_player/video_player.dart';
import '../model/empowerment_model.dart';

class EmpowermentVideoView extends StatefulWidget {
  final EmpowermentContent content;

  const EmpowermentVideoView({super.key, required this.content});

  @override
  State<EmpowermentVideoView> createState() => _EmpowermentVideoViewState();
}

class _EmpowermentVideoViewState extends State<EmpowermentVideoView> {
  YoutubePlayerController? _youtubeController;
  VideoPlayerController? _videoController;
  bool _isLocalVideo = false;

  @override
  void initState() {
    super.initState();

    // Check if it's a local video or YouTube video
    if (widget.content.videoPath != null) {
      _isLocalVideo = true;
      _videoController = VideoPlayerController.asset(widget.content.videoPath!)
        ..initialize().then((_) {
          setState(() {});
        });
    } else if (widget.content.youtubeVideoId != null) {
      _isLocalVideo = false;
      _youtubeController = YoutubePlayerController(
        initialVideoId: widget.content.youtubeVideoId!,
        flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
      );
    }
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            // Video Player Widget (YouTube or Local)
            _buildVideoPlayer(),

            // --- NEW: Redesigned Content Section ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.content.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
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
  }

  Widget _buildVideoPlayer() {
    if (_isLocalVideo && _videoController != null) {
      return _videoController!.value.isInitialized
          ? AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: Stack(
                children: [
                  VideoPlayer(_videoController!),
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _videoController!.value.isPlaying
                              ? _videoController!.pause()
                              : _videoController!.play();
                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Center(
                          child: Icon(
                            _videoController!.value.isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled,
                            size: 80,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator());
    } else if (!_isLocalVideo && _youtubeController != null) {
      return YoutubePlayer(controller: _youtubeController!);
    } else {
      return Container(
        height: 200,
        color: Colors.grey[300],
        child: const Center(child: Text('Video not available')),
      );
    }
  }
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
