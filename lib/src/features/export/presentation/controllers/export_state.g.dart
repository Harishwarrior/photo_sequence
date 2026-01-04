// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExportScreenState _$ExportScreenStateFromJson(Map<String, dynamic> json) =>
    ExportScreenState(
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      state:
          $enumDecodeNullable(_$ExportStateEnumMap, json['state']) ??
          ExportState.idle,
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$ExportScreenStateToJson(ExportScreenState instance) =>
    <String, dynamic>{
      'progress': instance.progress,
      'state': _$ExportStateEnumMap[instance.state]!,
      'errorMessage': instance.errorMessage,
    };

const _$ExportStateEnumMap = {
  ExportState.idle: 'idle',
  ExportState.preprocessing: 'preprocessing',
  ExportState.encoding: 'encoding',
  ExportState.saving: 'saving',
  ExportState.completed: 'completed',
  ExportState.failed: 'failed',
};
