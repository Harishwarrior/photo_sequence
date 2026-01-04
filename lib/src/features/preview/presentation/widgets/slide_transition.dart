import 'dart:io';
import 'package:flutter/material.dart';

import '../controllers/preview_controller.dart';

/// Widget that displays a single photo with slide transition.
class SlideTransitionWidget extends StatelessWidget {
  const SlideTransitionWidget({
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
        final offset = controller.getImageOffset(imageIndex);
        final isVisible = controller.isImageVisible(imageIndex);

        if (!isVisible) return const SizedBox.shrink();

        return SlideTransition(
          position: AlwaysStoppedAnimation(offset),
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

/// Builds a stack of slide transition widgets for all photos.
class SlideTransitionStack extends StatelessWidget {
  const SlideTransitionStack({super.key, required this.controller});

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
            // Photo layers (reverse order so incoming slides over outgoing)
            for (int i = 0; i < controller.project.photos.length; i++)
              Positioned.fill(
                child: SlideTransitionWidget(
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
