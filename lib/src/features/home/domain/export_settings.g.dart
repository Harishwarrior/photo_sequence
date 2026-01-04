// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExportSettings _$ExportSettingsFromJson(Map<String, dynamic> json) =>
    ExportSettings(
      width: (json['width'] as num?)?.toInt() ?? 1280,
      height: (json['height'] as num?)?.toInt() ?? 720,
      frameRate: (json['frameRate'] as num?)?.toInt() ?? 30,
      bitrate: (json['bitrate'] as num?)?.toInt() ?? 5000,
    );

Map<String, dynamic> _$ExportSettingsToJson(ExportSettings instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'frameRate': instance.frameRate,
      'bitrate': instance.bitrate,
    };
