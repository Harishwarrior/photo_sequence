import 'package:flutter/material.dart';

import '../../home/domain/photo_sequence_project.dart';
import '../../home/domain/transition_type.dart';
import '../application/preview_controller.dart';
import 'widgets/dissolve_transition.dart';
import 'widgets/preview_controls.dart';
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
