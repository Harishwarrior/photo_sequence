import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'compression_worker.dart';

/// Service for compressing and resizing images before FFmpeg processing.
///
/// This prevents OOM (Out of Memory) errors when processing high-resolution
/// photos (e.g., 108MP images from modern phones).
/// Also ensures all images are converted to JPEG format for FFmpeg compatibility.
class ImageCompressor {
  /// Maximum dimension (width or height) for processed images.
  static const int maxDimension = 1920;

  /// JPEG quality for compressed images.
  static const int quality = 95;

  /// Compress and resize images to a maximum dimension.
  /// All images are converted to JPEG format for FFmpeg min_gpl compatibility.
  ///
  /// Returns a list of paths to the processed JPEG images in the temp directory.
  Future<List<String>> compressImages(List<File> images) async {
    final tempDir = await getTemporaryDirectory();

    final args = CompressionArgs(
      imagePaths: images.map((f) => f.path).toList(),
      tempDirPath: tempDir.path,
      maxDimension: maxDimension,
      quality: quality,
    );

    // Run on main isolate because FlutterImageCompress uses platform channels
    return compressImagesWorker(args);
  }

  /// Clean up temporary processed images.
  Future<void> cleanupTempImages(List<String> paths) async {
    for (final path in paths) {
      try {
        final file = File(path);
        if (await file.exists() && path.contains('photo_sequence_')) {
          await file.delete();
        }
      } catch (_) {
        // Ignore cleanup errors
      }
    }
  }
}
