// Widget tests are limited because FFmpegKit only supports iOS/Android.
// Core logic tests are in:
// - duration_calculator_test.dart
// - ffmpeg_command_builder_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:photo_sequence/src/core/models/transition_type.dart';
import 'package:photo_sequence/src/core/models/export_settings.dart';

void main() {
  group('Models', () {
    test('TransitionType has correct FFmpeg values', () {
      expect(TransitionType.dissolve.ffmpegValue, 'fade');
      expect(TransitionType.slideLeft.ffmpegValue, 'slideleft');
    });

    test('ExportSettings presets have correct values', () {
      expect(ExportSettings.hd720.width, 1280);
      expect(ExportSettings.hd720.height, 720);
      expect(ExportSettings.hd1080.width, 1920);
      expect(ExportSettings.hd1080.height, 1080);
    });
  });
}
