import 'package:flutter/material.dart';

import '../../core/models/photo_sequence_project.dart';
import '../../core/models/transition_type.dart';
import 'preview_controller.dart';
import 'widgets/dissolve_transition.dart';
import 'widgets/slide_transition.dart';

/// Preview screen for viewing the photo sequence animation.
class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key, required this.project});

  final PhotoSequenceProject project;

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen>
    with SingleTickerProviderStateMixin {
  late PreviewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PreviewController(widget.project);
    _controller.initialize(this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSlideTransition =
        widget.project.transitionType != TransitionType.dissolve;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Preview'),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.download, color: Colors.white),
            label: const Text('Export', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: isSlideTransition
                    ? SlideTransitionStack(controller: _controller)
                    : DissolveTransitionStack(controller: _controller),
              ),
            ),
          ),
          PreviewControls(
            controller: _controller,
            totalDuration: widget.project.totalDuration,
          ),
        ],
      ),
    );
  }
}

/// Playback controls for the preview screen.
class PreviewControls extends StatelessWidget {
  const PreviewControls({
    super.key,
    required this.controller,
    required this.totalDuration,
  });

  final PreviewController controller;
  final Duration totalDuration;

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.black,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PreviewProgressSlider(
            controller: controller,
            totalDuration: totalDuration,
            formatDuration: _formatDuration,
          ),
          const SizedBox(height: 8),
          PreviewPlaybackButtons(controller: controller),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// Progress slider for preview timeline.
class PreviewProgressSlider extends StatelessWidget {
  const PreviewProgressSlider({
    super.key,
    required this.controller,
    required this.totalDuration,
    required this.formatDuration,
  });

  final PreviewController controller;
  final Duration totalDuration;
  final String Function(Duration) formatDuration;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return Row(
          children: [
            Text(
              formatDuration(
                Duration(
                  milliseconds: (controller.currentTimeSeconds * 1000).round(),
                ),
              ),
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Expanded(
              child: Slider(
                value: controller.progress,
                onChanged: controller.seekToProgress,
                activeColor: Colors.white,
                inactiveColor: Colors.white24,
              ),
            ),
            Text(
              formatDuration(totalDuration),
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        );
      },
    );
  }
}

/// Play, pause, and reset buttons.
class PreviewPlaybackButtons extends StatelessWidget {
  const PreviewPlaybackButtons({super.key, required this.controller});

  final PreviewController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: controller.reset,
          icon: const Icon(Icons.replay, color: Colors.white70),
        ),
        const SizedBox(width: 24),
        ListenableBuilder(
          listenable: controller,
          builder: (context, child) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: controller.togglePlayPause,
                icon: Icon(
                  controller.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.black,
                  size: 32,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 24),
        const SizedBox(width: 48),
      ],
    );
  }
}
