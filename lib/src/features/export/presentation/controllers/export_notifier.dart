import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../home/domain/photo_sequence_project.dart';
import '../../application/export_service.dart';
import 'export_state.dart';

part 'export_notifier.g.dart';

/// Provider for export screen state management.
@riverpod
class ExportNotifier extends _$ExportNotifier {
  final ExportService _exportService = ExportService();

  @override
  ExportScreenState build() {
    ref.onDispose(() {
      _exportService.cancel();
    });
    return const ExportScreenState();
  }

  Future<void> startExport(PhotoSequenceProject project) async {
    state = const ExportScreenState();

    await _exportService.export(
      project,
      onProgress: (progress) {
        state = state.copyWith(progress: progress);
      },
      onStateChange: (exportState) {
        state = state.copyWith(state: exportState);
      },
      onComplete: (_) {},
      onError: (error) {
        state = state.copyWith(errorMessage: error);
      },
    );
  }

  Future<void> cancel() async {
    await _exportService.cancel();
  }

  void retry(PhotoSequenceProject project) {
    state = const ExportScreenState();
    startExport(project);
  }
}
