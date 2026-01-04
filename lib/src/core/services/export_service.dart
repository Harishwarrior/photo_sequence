import 'dart:io';

import 'package:ffmpeg_kit_flutter_new_min_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new_min_gpl/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_new_min_gpl/return_code.dart';
import 'package:ffmpeg_kit_flutter_new_min_gpl/statistics.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../models/photo_sequence_project.dart';
import '../utils/ffmpeg_command_builder.dart';
import 'image_compressor.dart';
import 'storage_service.dart';

/// Export state enum
enum ExportState { idle, preprocessing, encoding, saving, completed, failed }

/// Service for exporting photo sequences to video using FFmpeg.
class ExportService {
  final FfmpegCommandBuilder _commandBuilder = FfmpegCommandBuilder();
  final ImageCompressor _imageCompressor = ImageCompressor();
  final StorageService _storageService = StorageService();

  /// Current export state
  ExportState _state = ExportState.idle;
  ExportState get state => _state;

  /// Cancel the current export.
  Future<void> cancel() async {
    await FFmpegKit.cancel();
    _state = ExportState.idle;
  }

  /// Export a photo sequence project to a video file.
  ///
  /// [project] - The photo sequence project to export
  /// [onProgress] - Callback with progress (0.0 to 1.0)
  /// [onStateChange] - Callback when export state changes
  /// [onComplete] - Callback when export completes successfully with output file
  /// [onError] - Callback when export fails with error message
  Future<void> export(
    PhotoSequenceProject project, {
    void Function(double progress)? onProgress,
    void Function(ExportState state)? onStateChange,
    void Function(File outputFile)? onComplete,
    void Function(String error)? onError,
  }) async {
    if (!project.isValid) {
      onError?.call('Project must have 3-5 photos');
      return;
    }

    try {
      // Step 1: Preprocessing - Compress images
      _updateState(ExportState.preprocessing, onStateChange);

      final processedImagePaths = await _imageCompressor.compressImages(
        project.photos,
      );

      // Step 2: Build FFmpeg command
      final tempDir = await getTemporaryDirectory();
      final outputPath = p.join(
        tempDir.path,
        'photo_sequence_${DateTime.now().millisecondsSinceEpoch}.mp4',
      );

      final commandArgs = _commandBuilder.buildCommandArgs(
        imagePaths: processedImagePaths,
        audioPath: project.backgroundMusic?.path,
        transition: project.transitionType,
        imageDurationSec: project.imageDurationSeconds,
        transitionDurationSec: project.transitionDurationSeconds,
        totalDuration: project.totalDurationSeconds,
        settings: project.exportSettings,
        outputPath: outputPath,
      );

      final command = commandArgs.join(' ');

      // Step 3: Execute FFmpeg
      _updateState(ExportState.encoding, onStateChange);

      // Enable statistics callback for progress
      final totalDurationMs = project.totalDuration.inMilliseconds;

      FFmpegKitConfig.enableStatisticsCallback((Statistics statistics) {
        final timeMs = statistics.getTime();
        if (timeMs > 0 && totalDurationMs > 0) {
          final progress = (timeMs / totalDurationMs).clamp(0.0, 1.0);
          onProgress?.call(progress);
        }
      });

      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();

      // Cleanup temp images
      await _imageCompressor.cleanupTempImages(processedImagePaths);

      if (ReturnCode.isSuccess(returnCode)) {
        // Step 4: Save to gallery
        _updateState(ExportState.saving, onStateChange);

        // Ensure we have permission
        await _storageService.requestGalleryAccess();
        final saved = await _storageService.saveVideoToGallery(outputPath);

        if (saved) {
          _updateState(ExportState.completed, onStateChange);
          onComplete?.call(File(outputPath));
        } else {
          // Still provide the file even if gallery save fails
          _updateState(ExportState.completed, onStateChange);
          onComplete?.call(File(outputPath));
        }
      } else {
        _updateState(ExportState.failed, onStateChange);

        final logs = await session.getAllLogsAsString();
        onError?.call('FFmpeg failed: $logs');
      }
    } catch (e) {
      _updateState(ExportState.failed, onStateChange);
      onError?.call('Export failed: $e');
    }
  }

  void _updateState(
    ExportState newState,
    void Function(ExportState)? callback,
  ) {
    _state = newState;
    callback?.call(newState);
  }

  /// Get the estimated file size in MB based on settings and duration.
  double estimateFileSizeMB(PhotoSequenceProject project) {
    final durationSec = project.totalDurationSeconds;
    final bitrateBps = project.exportSettings.bitrate * 1000;
    final fileSizeBytes = (bitrateBps * durationSec) / 8;
    return fileSizeBytes / (1024 * 1024);
  }
}
