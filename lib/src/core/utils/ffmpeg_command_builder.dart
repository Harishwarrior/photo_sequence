import '../models/export_settings.dart';
import '../models/transition_type.dart';

/// Builds FFmpeg commands for photo sequence video generation.
///
/// Handles complex filter graph construction with:
/// - Image standardization (scale, pad, setsar)
/// - xfade transitions with calculated offsets
/// - Audio mixing with looping and fade-out
class FfmpegCommandBuilder {
  /// Builds the complete FFmpeg command for exporting a photo sequence.
  ///
  /// [imagePaths] - List of absolute paths to input images
  /// [audioPath] - Optional path to background music
  /// [transition] - Transition type to use
  /// [imageDurationSec] - Duration each image is shown
  /// [transitionDurationSec] - Duration of transition effect
  /// [settings] - Export settings (resolution, bitrate, etc.)
  /// [outputPath] - Path for the output video file
  String buildCommand({
    required List<String> imagePaths,
    String? audioPath,
    required TransitionType transition,
    required double imageDurationSec,
    required double transitionDurationSec,
    required ExportSettings settings,
    required String outputPath,
  }) {
    if (imagePaths.isEmpty) {
      throw ArgumentError('At least one image is required');
    }

    final args = <String>[];

    // Input streams for images with loop and duration
    for (final path in imagePaths) {
      args.addAll([
        '-loop',
        '1',
        '-t',
        imageDurationSec.toString(),
        '-i',
        path,
      ]);
    }

    // Audio input with infinite loop (if provided)
    if (audioPath != null) {
      args.addAll(['-stream_loop', '-1', '-i', audioPath]);
    }

    // Build filter complex
    final filterComplex = _buildFilterComplex(
      imageCount: imagePaths.length,
      transition: transition,
      imageDurationSec: imageDurationSec,
      transitionDurationSec: transitionDurationSec,
      settings: settings,
      hasAudio: audioPath != null,
    );

    args.addAll(['-filter_complex', filterComplex]);

    // Map outputs
    args.addAll(['-map', '[video_out]']);
    if (audioPath != null) {
      args.addAll(['-map', '[audio_out]']);
    }

    // Output settings
    args.addAll([
      '-c:v',
      'libx264',
      '-preset',
      'medium',
      '-crf',
      '23',
      '-pix_fmt',
      'yuv420p',
      '-r',
      settings.frameRate.toString(),
    ]);

    if (audioPath != null) {
      args.addAll(['-c:a', 'aac', '-b:a', '192k', '-shortest']);
    }

    // Output file (overwrite if exists)
    args.addAll(['-y', outputPath]);

    return args.join(' ');
  }

  /// Returns the command as a list of arguments for executeCommandAsync
  List<String> buildCommandArgs({
    required List<String> imagePaths,
    String? audioPath,
    required TransitionType transition,
    required double imageDurationSec,
    required double transitionDurationSec,
    required ExportSettings settings,
    required String outputPath,
  }) {
    if (imagePaths.isEmpty) {
      throw ArgumentError('At least one image is required');
    }

    final args = <String>[];

    // Input streams for images with loop and duration
    for (final path in imagePaths) {
      args.addAll([
        '-loop',
        '1',
        '-t',
        imageDurationSec.toString(),
        '-i',
        path,
      ]);
    }

    // Audio input with infinite loop (if provided)
    if (audioPath != null) {
      args.addAll(['-stream_loop', '-1', '-i', audioPath]);
    }

    // Build filter complex
    final filterComplex = _buildFilterComplex(
      imageCount: imagePaths.length,
      transition: transition,
      imageDurationSec: imageDurationSec,
      transitionDurationSec: transitionDurationSec,
      settings: settings,
      hasAudio: audioPath != null,
    );

    args.addAll(['-filter_complex', filterComplex]);

    // Map outputs
    args.addAll(['-map', '[video_out]']);
    if (audioPath != null) {
      args.addAll(['-map', '[audio_out]']);
    }

    // Output settings
    args.addAll([
      '-c:v',
      'libx264',
      '-preset',
      'medium',
      '-crf',
      '23',
      '-pix_fmt',
      'yuv420p',
      '-r',
      settings.frameRate.toString(),
    ]);

    if (audioPath != null) {
      args.addAll(['-c:a', 'aac', '-b:a', '192k', '-shortest']);
    }

    // Output file (overwrite if exists)
    args.addAll(['-y', outputPath]);

    return args;
  }

  /// Builds the filter_complex string for FFmpeg.
  String _buildFilterComplex({
    required int imageCount,
    required TransitionType transition,
    required double imageDurationSec,
    required double transitionDurationSec,
    required ExportSettings settings,
    required bool hasAudio,
  }) {
    final filters = <String>[];
    final width = settings.width;
    final height = settings.height;

    // Step 1: Standardize all input images (scale, pad, setsar)
    for (int i = 0; i < imageCount; i++) {
      filters.add(
        '[$i:v]scale=$width:$height:force_original_aspect_ratio=decrease,'
        'pad=$width:$height:(ow-iw)/2:(oh-ih)/2,setsar=1,format=yuv420p[v$i]',
      );
    }

    // Step 2: Chain xfade transitions
    if (imageCount == 1) {
      // Single image, no transition needed
      filters.add('[v0]copy[video_out]');
    } else {
      // Calculate offsets
      final offsets = _calculateXfadeOffsets(
        imageCount: imageCount,
        imageDurationSec: imageDurationSec,
        transitionDurationSec: transitionDurationSec,
      );

      // Build xfade chain
      String previousStream = '[v0]';
      for (int i = 0; i < imageCount - 1; i++) {
        final nextStream = '[v${i + 1}]';
        final outputStream = i == imageCount - 2
            ? '[video_out]'
            : '[x${i + 1}]';
        final offset = offsets[i];

        filters.add(
          '$previousStream$nextStream'
          'xfade=transition=${transition.ffmpegValue}:'
          'duration=$transitionDurationSec:'
          'offset=$offset$outputStream',
        );

        previousStream = outputStream;
      }
    }

    // Step 3: Audio processing (if audio provided)
    if (hasAudio) {
      final audioIndex = imageCount; // Audio is the last input
      final totalDuration =
          (imageDurationSec * imageCount) -
          (transitionDurationSec * (imageCount - 1));
      final fadeStart = totalDuration - 2.0;

      if (fadeStart > 0) {
        filters.add('[$audioIndex:a]afade=t=out:st=$fadeStart:d=2[audio_out]');
      } else {
        filters.add('[$audioIndex:a]anull[audio_out]');
      }
    }

    return filters.join(';');
  }

  /// Calculates xfade offsets for each transition.
  ///
  /// Formula:
  /// O_1 = D_img - D_trans
  /// O_i = O_{i-1} + D_img - D_trans
  List<double> _calculateXfadeOffsets({
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
}
