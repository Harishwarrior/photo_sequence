import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../home/domain/photo_sequence_project.dart';
import '../application/export_service.dart';
import 'controllers/export_notifier.dart';
import 'widgets/export_error_content.dart';
import 'widgets/export_progress_content.dart';
import 'widgets/export_success_content.dart';

/// Export screen showing export progress.
class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key, required this.project});

  final PhotoSequenceProject project;

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(exportNotifierProvider.notifier).startExport(widget.project);
    });
  }

  void _handleCancel() async {
    await ref.read(exportNotifierProvider.notifier).cancel();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _handleRetry() {
    ref.read(exportNotifierProvider.notifier).retry(widget.project);
  }

  void _handleDone() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(exportNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Export'),
        leading:
            state.state == ExportState.completed ||
                state.state == ExportState.failed
            ? IconButton(icon: const Icon(Icons.close), onPressed: _handleDone)
            : null,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: switch (state.state) {
            ExportState.failed => ExportErrorContent(
              errorMessage: state.errorMessage,
              onCancel: _handleDone,
              onRetry: _handleRetry,
            ),
            ExportState.completed => ExportSuccessContent(onDone: _handleDone),
            _ => ExportProgressContent(
              state: state.state,
              progress: state.progress,
              onCancel: _handleCancel,
            ),
          },
        ),
      ),
    );
  }
}
