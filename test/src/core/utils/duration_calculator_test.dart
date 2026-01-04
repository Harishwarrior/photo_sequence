import 'package:flutter_test/flutter_test.dart';
import 'package:photo_sequence/src/core/utils/duration_calculator.dart';

void main() {
  group('DurationCalculator', () {
    group('totalDuration', () {
      test('calculates total duration for 3 images', () {
        // 3 images × 3s - 2 transitions × 1s = 7 seconds
        final result = DurationCalculator.totalDuration(
          imageCount: 3,
          imageDuration: const Duration(seconds: 3),
          transitionDuration: const Duration(seconds: 1),
        );
        expect(result, const Duration(seconds: 7));
      });

      test('calculates total duration for 5 images', () {
        // 5 images × 3s - 4 transitions × 1s = 11 seconds
        final result = DurationCalculator.totalDuration(
          imageCount: 5,
          imageDuration: const Duration(seconds: 3),
          transitionDuration: const Duration(seconds: 1),
        );
        expect(result, const Duration(seconds: 11));
      });

      test('calculates total duration with longer image duration', () {
        // 3 images × 5s - 2 transitions × 1s = 13 seconds
        final result = DurationCalculator.totalDuration(
          imageCount: 3,
          imageDuration: const Duration(seconds: 5),
          transitionDuration: const Duration(seconds: 1),
        );
        expect(result, const Duration(seconds: 13));
      });

      test('calculates total duration with longer transition duration', () {
        // 4 images × 4s - 3 transitions × 2s = 10 seconds
        final result = DurationCalculator.totalDuration(
          imageCount: 4,
          imageDuration: const Duration(seconds: 4),
          transitionDuration: const Duration(seconds: 2),
        );
        expect(result, const Duration(seconds: 10));
      });

      test('returns zero for empty image list', () {
        final result = DurationCalculator.totalDuration(
          imageCount: 0,
          imageDuration: const Duration(seconds: 3),
          transitionDuration: const Duration(seconds: 1),
        );
        expect(result, Duration.zero);
      });

      test('returns zero for negative image count', () {
        final result = DurationCalculator.totalDuration(
          imageCount: -1,
          imageDuration: const Duration(seconds: 3),
          transitionDuration: const Duration(seconds: 1),
        );
        expect(result, Duration.zero);
      });

      test('single image has no transitions', () {
        final result = DurationCalculator.totalDuration(
          imageCount: 1,
          imageDuration: const Duration(seconds: 3),
          transitionDuration: const Duration(seconds: 1),
        );
        expect(result, const Duration(seconds: 3));
      });

      test('two images have one transition', () {
        // 2 images × 4s - 1 transition × 1s = 7 seconds
        final result = DurationCalculator.totalDuration(
          imageCount: 2,
          imageDuration: const Duration(seconds: 4),
          transitionDuration: const Duration(seconds: 1),
        );
        expect(result, const Duration(seconds: 7));
      });

      test('handles millisecond precision', () {
        // 3 images × 2500ms - 2 transitions × 500ms = 6500ms
        final result = DurationCalculator.totalDuration(
          imageCount: 3,
          imageDuration: const Duration(milliseconds: 2500),
          transitionDuration: const Duration(milliseconds: 500),
        );
        expect(result, const Duration(milliseconds: 6500));
      });

      test('handles zero transition duration', () {
        // 3 images × 3s - 0 transitions = 9 seconds
        final result = DurationCalculator.totalDuration(
          imageCount: 3,
          imageDuration: const Duration(seconds: 3),
          transitionDuration: Duration.zero,
        );
        expect(result, const Duration(seconds: 9));
      });
    });

    group('xfadeOffsets', () {
      test('calculates xfade offsets for 3 images', () {
        // First offset: 5 - 1 = 4 seconds
        // Second offset: 4 + 5 - 1 = 8 seconds
        final offsets = DurationCalculator.xfadeOffsets(
          imageCount: 3,
          imageDurationSec: 5.0,
          transitionDurationSec: 1.0,
        );
        expect(offsets, [4.0, 8.0]);
      });

      test('calculates xfade offsets for 5 images', () {
        final offsets = DurationCalculator.xfadeOffsets(
          imageCount: 5,
          imageDurationSec: 3.0,
          transitionDurationSec: 1.0,
        );
        // Offsets at: 2, 4, 6, 8
        expect(offsets, [2.0, 4.0, 6.0, 8.0]);
      });

      test('returns empty list for single image', () {
        final offsets = DurationCalculator.xfadeOffsets(
          imageCount: 1,
          imageDurationSec: 3.0,
          transitionDurationSec: 1.0,
        );
        expect(offsets, isEmpty);
      });

      test('returns empty list for zero images', () {
        final offsets = DurationCalculator.xfadeOffsets(
          imageCount: 0,
          imageDurationSec: 3.0,
          transitionDurationSec: 1.0,
        );
        expect(offsets, isEmpty);
      });

      test('returns empty list for negative image count', () {
        final offsets = DurationCalculator.xfadeOffsets(
          imageCount: -1,
          imageDurationSec: 3.0,
          transitionDurationSec: 1.0,
        );
        expect(offsets, isEmpty);
      });

      test('handles 2 images case', () {
        final offsets = DurationCalculator.xfadeOffsets(
          imageCount: 2,
          imageDurationSec: 4.0,
          transitionDurationSec: 1.0,
        );
        expect(offsets, [3.0]);
      });

      test('handles longer transition duration', () {
        final offsets = DurationCalculator.xfadeOffsets(
          imageCount: 3,
          imageDurationSec: 5.0,
          transitionDurationSec: 2.0,
        );
        // First offset: 5 - 2 = 3 seconds
        // Second offset: 3 + 5 - 2 = 6 seconds
        expect(offsets, [3.0, 6.0]);
      });

      test('handles zero transition duration', () {
        final offsets = DurationCalculator.xfadeOffsets(
          imageCount: 3,
          imageDurationSec: 3.0,
          transitionDurationSec: 0.0,
        );
        // First offset: 3 - 0 = 3 seconds
        // Second offset: 3 + 3 - 0 = 6 seconds
        expect(offsets, [3.0, 6.0]);
      });

      test('handles fractional values', () {
        final offsets = DurationCalculator.xfadeOffsets(
          imageCount: 3,
          imageDurationSec: 2.5,
          transitionDurationSec: 0.5,
        );
        // First offset: 2.5 - 0.5 = 2.0 seconds
        // Second offset: 2.0 + 2.5 - 0.5 = 4.0 seconds
        expect(offsets, [2.0, 4.0]);
      });
    });

    group('imageTimeWindows', () {
      test('calculates time windows for 3 images', () {
        final windows = DurationCalculator.imageTimeWindows(
          imageCount: 3,
          imageDurationSec: 3.0,
          transitionDurationSec: 1.0,
        );

        expect(windows.length, 3);

        // Image 0: 0-3 seconds
        expect(windows[0].startTime, 0.0);
        expect(windows[0].endTime, 3.0);

        // Image 1: 2-5 seconds (starts at 3-1 = 2)
        expect(windows[1].startTime, 2.0);
        expect(windows[1].endTime, 5.0);

        // Image 2: 4-7 seconds (starts at 2 + 3 - 1 = 4)
        expect(windows[2].startTime, 4.0);
        expect(windows[2].endTime, 7.0);
      });

      test('calculates time windows for single image', () {
        final windows = DurationCalculator.imageTimeWindows(
          imageCount: 1,
          imageDurationSec: 5.0,
          transitionDurationSec: 1.0,
        );

        expect(windows.length, 1);
        expect(windows[0].startTime, 0.0);
        expect(windows[0].endTime, 5.0);
      });

      test('calculates time windows for 2 images', () {
        final windows = DurationCalculator.imageTimeWindows(
          imageCount: 2,
          imageDurationSec: 4.0,
          transitionDurationSec: 1.0,
        );

        expect(windows.length, 2);

        // Image 0: 0-4 seconds
        expect(windows[0].startTime, 0.0);
        expect(windows[0].endTime, 4.0);

        // Image 1: 3-7 seconds (starts at 4-1 = 3)
        expect(windows[1].startTime, 3.0);
        expect(windows[1].endTime, 7.0);
      });

      test('returns empty list for zero images', () {
        final windows = DurationCalculator.imageTimeWindows(
          imageCount: 0,
          imageDurationSec: 3.0,
          transitionDurationSec: 1.0,
        );
        expect(windows, isEmpty);
      });

      test('handles zero transition duration (no overlap)', () {
        final windows = DurationCalculator.imageTimeWindows(
          imageCount: 3,
          imageDurationSec: 2.0,
          transitionDurationSec: 0.0,
        );

        expect(windows.length, 3);

        // Image 0: 0-2 seconds
        expect(windows[0].startTime, 0.0);
        expect(windows[0].endTime, 2.0);

        // Image 1: 2-4 seconds (no overlap)
        expect(windows[1].startTime, 2.0);
        expect(windows[1].endTime, 4.0);

        // Image 2: 4-6 seconds (no overlap)
        expect(windows[2].startTime, 4.0);
        expect(windows[2].endTime, 6.0);
      });

      test('handles 5 images with overlapping windows', () {
        final windows = DurationCalculator.imageTimeWindows(
          imageCount: 5,
          imageDurationSec: 3.0,
          transitionDurationSec: 1.0,
        );

        expect(windows.length, 5);

        // Offset increment: 3 - 1 = 2
        expect(windows[0].startTime, 0.0);
        expect(windows[0].endTime, 3.0);

        expect(windows[1].startTime, 2.0);
        expect(windows[1].endTime, 5.0);

        expect(windows[2].startTime, 4.0);
        expect(windows[2].endTime, 7.0);

        expect(windows[3].startTime, 6.0);
        expect(windows[3].endTime, 9.0);

        expect(windows[4].startTime, 8.0);
        expect(windows[4].endTime, 11.0);
      });
    });

    group('controllerValueToTime', () {
      test('converts 0.0 to 0 seconds', () {
        expect(DurationCalculator.controllerValueToTime(0.0, 10.0), 0.0);
      });

      test('converts 1.0 to total duration', () {
        expect(DurationCalculator.controllerValueToTime(1.0, 10.0), 10.0);
      });

      test('converts 0.5 to half duration', () {
        expect(DurationCalculator.controllerValueToTime(0.5, 10.0), 5.0);
      });

      test('converts 0.25 to quarter duration', () {
        expect(DurationCalculator.controllerValueToTime(0.25, 20.0), 5.0);
      });

      test('handles zero total duration', () {
        expect(DurationCalculator.controllerValueToTime(0.5, 0.0), 0.0);
      });

      test('handles values greater than 1.0', () {
        expect(DurationCalculator.controllerValueToTime(1.5, 10.0), 15.0);
      });

      test('handles negative values', () {
        expect(DurationCalculator.controllerValueToTime(-0.5, 10.0), -5.0);
      });

      test('handles fractional total duration', () {
        expect(DurationCalculator.controllerValueToTime(0.5, 7.5), 3.75);
      });
    });

    group('timeToControllerValue', () {
      test('converts 0 seconds to 0.0', () {
        expect(DurationCalculator.timeToControllerValue(0.0, 10.0), 0.0);
      });

      test('converts total duration to 1.0', () {
        expect(DurationCalculator.timeToControllerValue(10.0, 10.0), 1.0);
      });

      test('converts half time to 0.5', () {
        expect(DurationCalculator.timeToControllerValue(5.0, 10.0), 0.5);
      });

      test('returns 0 for zero total duration', () {
        expect(DurationCalculator.timeToControllerValue(5.0, 0.0), 0.0);
      });

      test('returns 0 for negative total duration', () {
        expect(DurationCalculator.timeToControllerValue(5.0, -10.0), 0.0);
      });

      test('clamps value at 1.0 for time exceeding total', () {
        expect(DurationCalculator.timeToControllerValue(15.0, 10.0), 1.0);
      });

      test('clamps value at 0.0 for negative time', () {
        expect(DurationCalculator.timeToControllerValue(-5.0, 10.0), 0.0);
      });

      test('handles fractional values', () {
        final result = DurationCalculator.timeToControllerValue(2.5, 10.0);
        expect(result, closeTo(0.25, 0.0001));
      });
    });
  });
}
