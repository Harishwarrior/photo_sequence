import 'package:freezed_annotation/freezed_annotation.dart';

import '../../application/export_service.dart';

part 'export_state.freezed.dart';

/// State for the export screen.
@freezed
class ExportScreenState with _$ExportScreenState {
  const factory ExportScreenState({
    @Default(0.0) double progress,
    @Default(ExportState.idle) ExportState state,
    String? errorMessage,
  }) = _ExportScreenState;
}
