import 'package:flutter/material.dart';

import '../preview_controller.dart';

/// Progress slider for preview timeline.
class PreviewProgressSlider extends StatelessWidget {
  const PreviewProgressSlider({
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
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return Row(
          children: [
            Text(
              _formatDuration(
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
              _formatDuration(totalDuration),
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        );
      },
    );
  }
}
