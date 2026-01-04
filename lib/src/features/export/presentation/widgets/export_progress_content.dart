import 'package:flutter/material.dart';

import '../../application/export_service.dart';

/// Shows export progress with circular indicator.
class ExportProgressContent extends StatelessWidget {
  const ExportProgressContent({
    super.key,
    required this.state,
    required this.progress,
    required this.onCancel,
  });

  final ExportState state;
  final double progress;
  final VoidCallback onCancel;

  String get _statusText {
    switch (state) {
      case ExportState.idle:
        return 'Preparing...';
      case ExportState.preprocessing:
        return 'Processing images...';
      case ExportState.encoding:
        return 'Creating video...';
      case ExportState.saving:
        return 'Saving to gallery...';
      case ExportState.completed:
        return 'Complete!';
      case ExportState.failed:
        return 'Failed';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: Stack(
            fit: StackFit.expand,
            children: [
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                tween: Tween<double>(
                  begin: 0,
                  end: state == ExportState.preprocessing ? 0 : progress,
                ),
                builder: (context, value, _) {
                  return CircularProgressIndicator(
                    value: state == ExportState.preprocessing ? null : value,
                    strokeWidth: 8,
                    backgroundColor: Colors.white12,
                    color: Colors.white,
                  );
                },
              ),
              Center(
                child: Text(
                  state == ExportState.preprocessing
                      ? '...'
                      : '${(progress * 100).round()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Text(
          _statusText,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
        const SizedBox(height: 48),
        OutlinedButton(
          onPressed: onCancel,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.white38),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
