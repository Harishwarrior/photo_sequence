import 'package:equatable/equatable.dart';

/// Export settings for video generation.
class ExportSettings extends Equatable {
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

  @override
  List<Object?> get props => [width, height, frameRate, bitrate];
}
