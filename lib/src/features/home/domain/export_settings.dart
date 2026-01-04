import 'package:json_annotation/json_annotation.dart';

part 'export_settings.g.dart';

/// Export settings for video generation.
@JsonSerializable()
class ExportSettings {
  /// Target video width in pixels
  final int width;

  /// Target video height in pixels
  final int height;

  /// Video frame rate (fps)
  final int frameRate;

  /// Video bitrate in kbps
  final int bitrate;

  const ExportSettings({
    this.width = 1280,
    this.height = 720,
    this.frameRate = 30,
    this.bitrate = 5000,
  });

  /// 720p preset (default)
  static const hd720 = ExportSettings(
    width: 1280,
    height: 720,
    frameRate: 30,
    bitrate: 5000,
  );

  /// 1080p preset
  static const hd1080 = ExportSettings(
    width: 1920,
    height: 1080,
    frameRate: 30,
    bitrate: 8000,
  );

  /// Resolution string for FFmpeg
  String get resolution => '${width}x$height';

  ExportSettings copyWith({
    int? width,
    int? height,
    int? frameRate,
    int? bitrate,
  }) {
    return ExportSettings(
      width: width ?? this.width,
      height: height ?? this.height,
      frameRate: frameRate ?? this.frameRate,
      bitrate: bitrate ?? this.bitrate,
    );
  }

  factory ExportSettings.fromJson(Map<String, dynamic> json) =>
      _$ExportSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$ExportSettingsToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExportSettings &&
          runtimeType == other.runtimeType &&
          width == other.width &&
          height == other.height &&
          frameRate == other.frameRate &&
          bitrate == other.bitrate;

  @override
  int get hashCode =>
      width.hashCode ^ height.hashCode ^ frameRate.hashCode ^ bitrate.hashCode;
}
