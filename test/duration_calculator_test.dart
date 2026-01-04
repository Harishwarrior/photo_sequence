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

      test('returns zero for empty image list', () {
        final result = DurationCalculator.totalDuration(
          imageCount: 0,
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

      test('handles 2 images case', () {
        final offsets = DurationCalculator.xfadeOffsets(
          imageCount: 2,
          imageDurationSec: 4.0,
          transitionDurationSec: 1.0,
        );
        expect(offsets, [3.0]);
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
    });

    group('timeToControllerValue', () {
      test('converts 0 seconds to 0.0', () {
        expect(DurationCalculator.timeToControllerValue(0.0, 10.0), 0.0);
      });

      test('converts total duration to 1.0', () {
        expect(DurationCalculator.timeToControllerValue(10.0, 10.0), 1.0);
      });

      test('returns 0 for zero total duration', () {
        expect(DurationCalculator.timeToControllerValue(5.0, 0.0), 0.0);
      });
    });
  });
}
