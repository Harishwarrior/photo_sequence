import 'package:flutter/material.dart';

import '../../core/models/photo_sequence_project.dart';
import '../../core/services/export_service.dart';

/// Export screen showing export progress.
class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key, required this.project});

  final PhotoSequenceProject project;

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  final ExportService _exportService = ExportService();

  double _progress = 0.0;
  ExportState _state = ExportState.idle;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startExport();
  }

  Future<void> _startExport() async {
    await _exportService.export(
      widget.project,
      onProgress: (progress) {
        setState(() {
          _progress = progress;
        });
      },
      onStateChange: (state) {
        setState(() {
          _state = state;
        });
      },
      onComplete: (_) {
        // Video saved successfully, state is already updated
      },
      onError: (error) {
        setState(() {
          _errorMessage = error;
        });
      },
    );
  }

  void _handleCancel() async {
    await _exportService.cancel();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _handleRetry() {
    setState(() {
      _progress = 0;
      _state = ExportState.idle;
      _errorMessage = null;
    });
    _startExport();
  }

  void _handleDone() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Export'),
        leading: _state == ExportState.completed || _state == ExportState.failed
            ? IconButton(icon: const Icon(Icons.close), onPressed: _handleDone)
            : null,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: switch (_state) {
            ExportState.failed => ExportErrorContent(
              errorMessage: _errorMessage,
              onCancel: _handleDone,
              onRetry: _handleRetry,
            ),
            ExportState.completed => ExportSuccessContent(onDone: _handleDone),
            _ => ExportProgressContent(
              state: _state,
              progress: _progress,
              onCancel: _handleCancel,
            ),
          },
        ),
      ),
    );
  }
}

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

/// Shows export success state.
class ExportSuccessContent extends StatelessWidget {
  const ExportSuccessContent({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 64),
        ),
        const SizedBox(height: 32),
        const Text(
          'Video Saved!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Your video has been saved to the gallery.',
          style: TextStyle(color: Colors.white70, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),
        ElevatedButton(
          onPressed: onDone,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
          child: const Text('Done'),
        ),
      ],
    );
  }
}

/// Shows export error state.
class ExportErrorContent extends StatelessWidget {
  const ExportErrorContent({
    super.key,
    required this.errorMessage,
    required this.onCancel,
    required this.onRetry,
  });

  final String? errorMessage;
  final VoidCallback onCancel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.error_outline, color: Colors.white, size: 64),
        ),
        const SizedBox(height: 32),
        const Text(
          'Export Failed',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          errorMessage ?? 'An unknown error occurred.',
          style: const TextStyle(color: Colors.white70, fontSize: 14),
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 48),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white38),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ],
    );
  }
}
