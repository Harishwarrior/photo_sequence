import 'package:flutter/material.dart';

import '../../application/preview_controller.dart';
import 'preview_playback_buttons.dart';
import 'preview_progress_slider.dart';

/// Playback controls for the preview screen.
class PreviewControls extends StatelessWidget {
  const PreviewControls({
    super.key,
    required this.controller,
    required this.totalDuration,
  });

  final PreviewController controller;
  final Duration totalDuration;

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
          ),
          const SizedBox(height: 8),
          PreviewPlaybackButtons(controller: controller),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
