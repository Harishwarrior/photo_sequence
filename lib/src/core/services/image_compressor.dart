import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Service for compressing and resizing images before FFmpeg processing.
///
/// This prevents OOM (Out of Memory) errors when processing high-resolution
/// photos (e.g., 108MP images from modern phones).
class ImageCompressor {
  /// Maximum dimension (width or height) for processed images.
  static const int maxDimension = 1920;

  /// JPEG quality for compressed images.
  static const int quality = 95;

  /// Compress and resize images to a maximum dimension.
  ///
  /// Returns a list of paths to the processed images in the temp directory.
  Future<List<String>> compressImages(List<File> images) async {
    final tempDir = await getTemporaryDirectory();
    final processedPaths = <String>[];

    for (int i = 0; i < images.length; i++) {
      final image = images[i];
      final outputPath = p.join(
        tempDir.path,
        'photo_sequence_${i}_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      final result = await FlutterImageCompress.compressAndGetFile(
        image.path,
        outputPath,
        minWidth: maxDimension,
        minHeight: maxDimension,
        quality: quality,
        keepExif: false,
      );

      if (result != null) {
        processedPaths.add(result.path);
      } else {
        // If compression fails, use original
        processedPaths.add(image.path);
      }
    }

    return processedPaths;
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
