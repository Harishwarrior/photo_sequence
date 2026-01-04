import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'compression_worker.dart';

/// Service for compressing and resizing images before FFmpeg processing.
class ImageCompressor {
  static const int maxDimension = 1920;
  static const int quality = 95;

  Future<List<String>> compressImages(List<File> images) async {
    final tempDir = await getTemporaryDirectory();

    final args = CompressionArgs(
      imagePaths: images.map((f) => f.path).toList(),
      tempDirPath: tempDir.path,
      maxDimension: maxDimension,
      quality: quality,
    );

    return compressImagesWorker(args);
  }

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
