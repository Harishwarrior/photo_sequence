import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../home/domain/photo_sequence_project.dart';
import '../data/export_service.dart';

part 'export_state.freezed.dart';
part 'export_state.g.dart';

/// State for the export screen.
@freezed
class ExportScreenState with _$ExportScreenState {
  const factory ExportScreenState({
    @Default(0.0) double progress,
    @Default(ExportState.idle) ExportState state,
    String? errorMessage,
  }) = _ExportScreenState;
}

/// Provider for export screen state management.
@riverpod
class ExportNotifier extends _$ExportNotifier {
  final ExportService _exportService = ExportService();

  @override
  ExportScreenState build() => const ExportScreenState();

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
