import 'package:flutter_test/flutter_test.dart';
import 'package:photo_sequence/src/core/models/export_settings.dart';
import 'package:photo_sequence/src/core/models/transition_type.dart';
import 'package:photo_sequence/src/core/utils/ffmpeg_command_builder.dart';

void main() {
  group('FfmpegCommandBuilder', () {
    late FfmpegCommandBuilder builder;

    setUp(() {
      builder = FfmpegCommandBuilder();
    });

    group('buildCommand', () {
      test('builds valid command with dissolve transition', () {
        final command = builder.buildCommand(
          imagePaths: ['/tmp/1.jpg', '/tmp/2.jpg', '/tmp/3.jpg'],
          audioPath: '/tmp/music.mp3',
          transition: TransitionType.dissolve,
          imageDurationSec: 3.0,
          transitionDurationSec: 1.0,
          settings: ExportSettings.hd720,
          outputPath: '/tmp/output.mp4',
        );

        // Check for dissolve transition (fade)
        expect(command, contains('xfade=transition=fade'));

        // Check for correct offsets (2 and 4 for 3 images, 3s duration, 1s transition)
        expect(command, contains('offset=2'));
        expect(command, contains('offset=4'));

        // Check for pixel format
        expect(command, contains('-pix_fmt yuv420p'));

        // Check for output file
        expect(command, contains('/tmp/output.mp4'));

        // Check for audio
        expect(command, contains('/tmp/music.mp3'));
        expect(command, contains('-shortest'));
      });

      test('builds valid command with slide left transition', () {
        final command = builder.buildCommand(
          imagePaths: ['/tmp/1.jpg', '/tmp/2.jpg'],
          transition: TransitionType.slideLeft,
          imageDurationSec: 4.0,
          transitionDurationSec: 1.0,
          settings: ExportSettings.hd720,
          outputPath: '/tmp/output.mp4',
        );

        expect(command, contains('xfade=transition=slideleft'));
        expect(command, contains('offset=3'));
      });

      test('builds valid command without audio', () {
        final command = builder.buildCommand(
          imagePaths: ['/tmp/1.jpg', '/tmp/2.jpg', '/tmp/3.jpg'],
          transition: TransitionType.dissolve,
          imageDurationSec: 3.0,
          transitionDurationSec: 1.0,
          settings: ExportSettings.hd720,
          outputPath: '/tmp/output.mp4',
        );

        // Should not contain audio-related flags
        expect(command, isNot(contains('-stream_loop -1')));
        expect(command, isNot(contains('-shortest')));
      });

      test('includes resolution scaling in filter complex', () {
        final command = builder.buildCommand(
          imagePaths: ['/tmp/1.jpg', '/tmp/2.jpg'],
          transition: TransitionType.dissolve,
          imageDurationSec: 3.0,
          transitionDurationSec: 1.0,
          settings: ExportSettings.hd720,
          outputPath: '/tmp/output.mp4',
        );

        // Check for standardization filter chain
        expect(command, contains('scale=1280:720'));
        expect(command, contains('force_original_aspect_ratio=decrease'));
        expect(command, contains('pad=1280:720'));
        expect(command, contains('setsar=1'));
      });

      test('uses 1080p settings when specified', () {
        final command = builder.buildCommand(
          imagePaths: ['/tmp/1.jpg', '/tmp/2.jpg'],
          transition: TransitionType.dissolve,
          imageDurationSec: 3.0,
          transitionDurationSec: 1.0,
          settings: ExportSettings.hd1080,
          outputPath: '/tmp/output.mp4',
        );

        expect(command, contains('scale=1920:1080'));
        expect(command, contains('pad=1920:1080'));
      });

      test('throws error for empty image list', () {
        expect(
          () => builder.buildCommand(
            imagePaths: [],
            transition: TransitionType.dissolve,
            imageDurationSec: 3.0,
            transitionDurationSec: 1.0,
            settings: ExportSettings.hd720,
            outputPath: '/tmp/output.mp4',
          ),
          throwsArgumentError,
        );
      });
    });

    group('buildCommandArgs', () {
      test('returns list of arguments', () {
        final args = builder.buildCommandArgs(
          imagePaths: ['/tmp/1.jpg', '/tmp/2.jpg'],
          transition: TransitionType.dissolve,
          imageDurationSec: 3.0,
          transitionDurationSec: 1.0,
          totalDuration: 5.0,
          settings: ExportSettings.hd720,
          outputPath: '/tmp/output.mp4',
        );

        expect(args, isA<List<String>>());
        expect(args, contains('-loop'));
        expect(args, contains('-filter_complex'));
        expect(args, contains('-map'));
      });
    });
  });

  group('TransitionType', () {
    test('dissolve maps to fade', () {
      expect(TransitionType.dissolve.ffmpegValue, 'fade');
    });

    test('slideLeft maps to slideleft', () {
      expect(TransitionType.slideLeft.ffmpegValue, 'slideleft');
    });

    test('slideRight maps to slideright', () {
      expect(TransitionType.slideRight.ffmpegValue, 'slideright');
    });

    test('slideUp maps to slideup', () {
      expect(TransitionType.slideUp.ffmpegValue, 'slideup');
    });

    test('slideDown maps to slidedown', () {
      expect(TransitionType.slideDown.ffmpegValue, 'slidedown');
    });
  });
}
