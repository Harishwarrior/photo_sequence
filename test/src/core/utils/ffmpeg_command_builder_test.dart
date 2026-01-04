import 'package:flutter_test/flutter_test.dart';
import 'package:photo_sequence/src/core/utils/ffmpeg_command_builder.dart';
import 'package:photo_sequence/src/features/home/domain/export_settings.dart';
import 'package:photo_sequence/src/features/home/domain/transition_type.dart';

void main() {
  late FfmpegCommandBuilder builder;
  late ExportSettings settings720p;
  late ExportSettings settings1080p;

  setUp(() {
    builder = FfmpegCommandBuilder();
    settings720p = ExportSettings(
      width: 1280,
      height: 720,
      frameRate: 30,
      bitrate: 5000000,
    );
    settings1080p = ExportSettings(
      width: 1920,
      height: 1080,
      frameRate: 30,
      bitrate: 8000000,
    );
  });

  group('FfmpegCommandBuilder', () {
    group('buildCommand', () {
      test('throws ArgumentError for empty image list', () {
        expect(
          () => builder.buildCommand(
            imagePaths: [],
            transition: TransitionType.dissolve,
            imageDurationSec: 3.0,
            transitionDurationSec: 1.0,
            settings: settings720p,
            outputPath: '/output/video.mp4',
          ),
          throwsArgumentError,
        );
      });

      test('builds command for single image without transitions', () {
        final command = builder.buildCommand(
          imagePaths: ['/path/image1.jpg'],
          transition: TransitionType.dissolve,
          imageDurationSec: 3.0,
          transitionDurationSec: 1.0,
          settings: settings720p,
          outputPath: '/output/video.mp4',
        );

        expect(command, contains('-i'));
        expect(command, contains('/path/image1.jpg'));
        expect(command, contains('-filter_complex'));
        expect(command, contains('[video_out]'));
        expect(command, contains('-y /output/video.mp4'));
      });

      test('builds command for multiple images with dissolve transition', () {
        final command = builder.buildCommand(
          imagePaths: ['/path/image1.jpg', '/path/image2.jpg'],
          transition: TransitionType.dissolve,
          imageDurationSec: 3.0,
          transitionDurationSec: 1.0,
          settings: settings720p,
          outputPath: '/output/video.mp4',
        );

        expect(command, contains('xfade=transition=fade'));
        expect(command, contains('duration=1.0'));
      });

      test('builds command for slideLeft transition', () {
        final command = builder.buildCommand(
          imagePaths: ['/path/image1.jpg', '/path/image2.jpg'],
          transition: TransitionType.slideLeft,
          imageDurationSec: 3.0,
          transitionDurationSec: 1.0,
          settings: settings720p,
          outputPath: '/output/video.mp4',
        );

        expect(command, contains('xfade=transition=slideleft'));
      });

      test('builds command for slideRight transition', () {
        final command = builder.buildCommand(
          imagePaths: ['/path/image1.jpg', '/path/image2.jpg'],
          transition: TransitionType.slideRight,
          imageDurationSec: 3.0,
          transitionDurationSec: 1.0,
          settings: settings720p,
          outputPath: '/output/video.mp4',
        );

        expect(command, contains('xfade=transition=slideright'));
      });

      test('builds command for slideUp transition', () {
        final command = builder.buildCommand(
          imagePaths: ['/path/image1.jpg', '/path/image2.jpg'],
          transition: TransitionType.slideUp,
          imageDurationSec: 3.0,
          transitionDurationSec: 1.0,
          settings: settings720p,
          outputPath: '/output/video.mp4',
        );

        expect(command, contains('xfade=transition=slideup'));
      });

      test('builds command for slideDown transition', () {
        final command = builder.buildCommand(
          imagePaths: ['/path/image1.jpg', '/path/image2.jpg'],
          transition: TransitionType.slideDown,
          imageDurationSec: 3.0,
          transitionDurationSec: 1.0,
          settings: settings720p,
          outputPath: '/output/video.mp4',
        );

        expect(command, contains('xfade=transition=slidedown'));
      });

      test('includes audio input when audioPath is provided', () {
        final command = builder.buildCommand(
          imagePaths: ['/path/image1.jpg', '/path/image2.jpg'],
          audioPath: '/path/audio.mp3',
          transition: TransitionType.dissolve,
          imageDurationSec: 3.0,
          transitionDurationSec: 1.0,
          settings: settings720p,
          outputPath: '/output/video.mp4',
        );

        expect(command, contains('-stream_loop -1'));
        expect(command, contains('/path/audio.mp3'));
        expect(command, contains('[audio_out]'));
        expect(command, contains('-c:a aac'));
        expect(command, contains('-b:a 192k'));
        expect(command, contains('-shortest'));
      });

      test('uses correct resolution for 1080p settings', () {
        final command = builder.buildCommand(
          imagePaths: ['/path/image1.jpg'],
          transition: TransitionType.dissolve,
          imageDurationSec: 3.0,
          transitionDurationSec: 1.0,
          settings: settings1080p,
          outputPath: '/output/video.mp4',
        );

        expect(command, contains('scale=1920:1080'));
        expect(command, contains('pad=1920:1080'));
      });

      test('uses correct frame rate from settings', () {
        final settingsCustomFps = ExportSettings(
          width: 1280,
          height: 720,
          frameRate: 60,
          bitrate: 5000000,
        );

        final command = builder.buildCommand(
          imagePaths: ['/path/image1.jpg'],
          transition: TransitionType.dissolve,
          imageDurationSec: 3.0,
          transitionDurationSec: 1.0,
          settings: settingsCustomFps,
          outputPath: '/output/video.mp4',
        );

        expect(command, contains('-r 60'));
      });

      test('includes required video codec settings', () {
        final command = builder.buildCommand(
          imagePaths: ['/path/image1.jpg'],
          transition: TransitionType.dissolve,
          imageDurationSec: 3.0,
          transitionDurationSec: 1.0,
          settings: settings720p,
          outputPath: '/output/video.mp4',
        );

        expect(command, contains('-c:v libx264'));
        expect(command, contains('-preset medium'));
        expect(command, contains('-crf 23'));
        expect(command, contains('-pix_fmt yuv420p'));
      });
    });

    group('buildCommandArgs', () {
      test('throws ArgumentError for empty image list', () {
        expect(
          () => builder.buildCommandArgs(
            imagePaths: [],
            transition: TransitionType.dissolve,
            imageDurationSec: 3.0,
            transitionDurationSec: 1.0,
            totalDuration: 5.0,
            settings: settings720p,
            outputPath: '/output/video.mp4',
          ),
          throwsArgumentError,
        );
      });

      test('returns list of arguments instead of joined string', () {
        final args = builder.buildCommandArgs(
          imagePaths: ['/path/image1.jpg', '/path/image2.jpg'],
          transition: TransitionType.dissolve,
          imageDurationSec: 3.0,
          transitionDurationSec: 1.0,
          totalDuration: 5.0,
          settings: settings720p,
          outputPath: '/output/video.mp4',
        );

        expect(args, isA<List<String>>());
        expect(args, contains('-i'));
        expect(args, contains('/path/image1.jpg'));
        expect(args, contains('/path/image2.jpg'));
      });

      test('includes total duration in args', () {
        final args = builder.buildCommandArgs(
          imagePaths: ['/path/image1.jpg', '/path/image2.jpg'],
          transition: TransitionType.dissolve,
          imageDurationSec: 3.0,
          transitionDurationSec: 1.0,
          totalDuration: 7.5,
          settings: settings720p,
          outputPath: '/output/video.mp4',
        );

        // The total duration -t appears near the end (after codec settings)
        // Find the last occurrence of -t
        int lastTIndex = -1;
        for (int i = args.length - 1; i >= 0; i--) {
          if (args[i] == '-t') {
            lastTIndex = i;
            break;
          }
        }
        expect(lastTIndex, greaterThan(-1));
        expect(args[lastTIndex + 1], '7.5');
      });

      test('uses ultrafast preset for args version', () {
        final args = builder.buildCommandArgs(
          imagePaths: ['/path/image1.jpg'],
          transition: TransitionType.dissolve,
          imageDurationSec: 3.0,
          transitionDurationSec: 1.0,
          totalDuration: 3.0,
          settings: settings720p,
          outputPath: '/output/video.mp4',
        );

        expect(args, contains('-preset'));
        final presetIndex = args.indexOf('-preset');
        expect(args[presetIndex + 1], 'ultrafast');
      });

      test('correctly orders all input streams', () {
        final args = builder.buildCommandArgs(
          imagePaths: ['/path/1.jpg', '/path/2.jpg', '/path/3.jpg'],
          audioPath: '/path/audio.mp3',
          transition: TransitionType.dissolve,
          imageDurationSec: 3.0,
          transitionDurationSec: 1.0,
          totalDuration: 7.0,
          settings: settings720p,
          outputPath: '/output/video.mp4',
        );

        // All images and audio should be present
        expect(args, contains('/path/1.jpg'));
        expect(args, contains('/path/2.jpg'));
        expect(args, contains('/path/3.jpg'));
        expect(args, contains('/path/audio.mp3'));
      });
    });

    group('filter graph construction', () {
      test('includes scale and pad for image standardization', () {
        final command = builder.buildCommand(
          imagePaths: ['/path/image1.jpg'],
          transition: TransitionType.dissolve,
          imageDurationSec: 3.0,
          transitionDurationSec: 1.0,
          settings: settings720p,
          outputPath: '/output/video.mp4',
        );

        expect(
          command,
          contains('scale=1280:720:force_original_aspect_ratio=decrease'),
        );
        expect(command, contains('pad=1280:720:(ow-iw)/2:(oh-ih)/2'));
        expect(command, contains('setsar=1'));
        expect(command, contains('format=yuv420p'));
      });

      test('generates correct number of xfade transitions', () {
        final command = builder.buildCommand(
          imagePaths: [
            '/path/1.jpg',
            '/path/2.jpg',
            '/path/3.jpg',
            '/path/4.jpg',
          ],
          transition: TransitionType.dissolve,
          imageDurationSec: 3.0,
          transitionDurationSec: 1.0,
          settings: settings720p,
          outputPath: '/output/video.mp4',
        );

        // 4 images = 3 xfade transitions
        final xfadeCount = 'xfade'.allMatches(command).length;
        expect(xfadeCount, 3);
      });

      test('includes audio fade out for provided audio', () {
        final command = builder.buildCommand(
          imagePaths: ['/path/1.jpg', '/path/2.jpg', '/path/3.jpg'],
          audioPath: '/path/audio.mp3',
          transition: TransitionType.dissolve,
          imageDurationSec: 3.0,
          transitionDurationSec: 1.0,
          settings: settings720p,
          outputPath: '/output/video.mp4',
        );

        expect(command, contains('afade=t=out'));
      });
    });
  });
}
