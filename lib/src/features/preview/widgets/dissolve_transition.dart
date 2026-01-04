import 'dart:io';
import 'package:flutter/material.dart';

import '../preview_controller.dart';

/// Widget that displays a single photo with dissolve (crossfade) transition.
class DissolveTransitionWidget extends StatelessWidget {
  const DissolveTransitionWidget({
    super.key,
    required this.controller,
    required this.imageIndex,
    required this.image,
  });

  final PreviewController controller;
  final int imageIndex;
  final File image;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        final opacity = controller.getImageOpacity(imageIndex);
        final isVisible = opacity > 0;

        if (!isVisible) return const SizedBox.shrink();

        return Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: Image.file(
            image,
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
          ),
        );
      },
    );
  }
}

/// Builds a stack of dissolve transition widgets for all photos.
class DissolveTransitionStack extends StatelessWidget {
  const DissolveTransitionStack({super.key, required this.controller});

  final PreviewController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return Stack(
          fit: StackFit.expand,
          children: [
            // Black background
            Container(color: Colors.black),
            // Photo layers
            for (int i = 0; i < controller.project.photos.length; i++)
              Positioned.fill(
                child: DissolveTransitionWidget(
                  controller: controller,
                  imageIndex: i,
                  image: controller.project.photos[i],
                ),
              ),
          ],
        );
      },
    );
  }
}
