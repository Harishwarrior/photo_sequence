import 'package:json_annotation/json_annotation.dart';
import '../../application/export_service.dart';

part 'export_state.g.dart';

/// State for the export screen.
@JsonSerializable()
class ExportScreenState {
  final double progress;
  final ExportState state;
  final String? errorMessage;

  const ExportScreenState({
    this.progress = 0.0,
    this.state = ExportState.idle,
    this.errorMessage,
  });

  ExportScreenState copyWith({
    double? progress,
    ExportState? state,
    String? errorMessage,
  }) {
    return ExportScreenState(
      progress: progress ?? this.progress,
      state: state ?? this.state,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory ExportScreenState.fromJson(Map<String, dynamic> json) =>
      _$ExportScreenStateFromJson(json);

  Map<String, dynamic> toJson() => _$ExportScreenStateToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExportScreenState &&
          runtimeType == other.runtimeType &&
          progress == other.progress &&
          state == other.state &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode =>
      progress.hashCode ^ state.hashCode ^ errorMessage.hashCode;
}
