import 'package:flutter/material.dart';

import '../controllers/preview_controller.dart';

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
