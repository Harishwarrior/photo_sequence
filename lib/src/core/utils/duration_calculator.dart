/// Utility class for calculating durations and timestamps in photo sequences.
class DurationCalculator {
  /// Calculates the total duration of the photo sequence.
  ///
  /// Formula: (N × D_img) - ((N-1) × D_trans)
  /// Example: 3 images × 3s - 2 transitions × 1s = 7 seconds
  static Duration totalDuration({
    required int imageCount,
    required Duration imageDuration,
    required Duration transitionDuration,
  }) {
    if (imageCount <= 0) return Duration.zero;
    final imageMs = imageDuration.inMilliseconds * imageCount;
    final transitionMs = transitionDuration.inMilliseconds * (imageCount - 1);
    return Duration(milliseconds: imageMs - transitionMs);
  }

  /// Calculates the xfade offset values for FFmpeg transitions.
  ///
  /// Formula:
  /// O_1 = D_img - D_trans
  /// O_i = O_{i-1} + D_img - D_trans
  ///
  /// Example for 3 images, 5s duration, 1s transition:
  /// - Offset 1: 5 - 1 = 4 seconds
  /// - Offset 2: 4 + 5 - 1 = 8 seconds
  static List<double> xfadeOffsets({
    required int imageCount,
    required double imageDurationSec,
    required double transitionDurationSec,
  }) {
    if (imageCount <= 1) return [];

    final offsets = <double>[];
    double currentOffset = imageDurationSec - transitionDurationSec;

    for (int i = 0; i < imageCount - 1; i++) {
      offsets.add(currentOffset);
      currentOffset += imageDurationSec - transitionDurationSec;
    }
    return offsets;
  }

  /// Calculates the time windows for each image visibility.
  ///
  /// Returns a list of (startTime, endTime) tuples for each image.
  /// Used for preview animation synchronization.
  static List<({double startTime, double endTime})> imageTimeWindows({
    required int imageCount,
    required double imageDurationSec,
    required double transitionDurationSec,
  }) {
    final windows = <({double startTime, double endTime})>[];
    double currentStart = 0;

    for (int i = 0; i < imageCount; i++) {
      windows.add((
        startTime: currentStart,
        endTime: currentStart + imageDurationSec,
      ));
      currentStart += imageDurationSec - transitionDurationSec;
    }
    return windows;
  }

  /// Converts a controller value (0.0 to 1.0) to time in seconds.
  static double controllerValueToTime(double value, double totalDurationSec) {
    return value * totalDurationSec;
  }

  /// Converts time in seconds to a controller value (0.0 to 1.0).
  static double timeToControllerValue(double timeSec, double totalDurationSec) {
    if (totalDurationSec <= 0) return 0;
    return (timeSec / totalDurationSec).clamp(0.0, 1.0);
  }
}
