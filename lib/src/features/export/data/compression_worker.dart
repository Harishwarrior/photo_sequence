import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;

/// Arguments for the compression worker
class CompressionArgs {
  final List<String> imagePaths;
  final String tempDirPath;
  final int maxDimension;
  final int quality;

  CompressionArgs({
    required this.imagePaths,
    required this.tempDirPath,
    required this.maxDimension,
    required this.quality,
  });
}

/// Compresses images on the main isolate (FlutterImageCompress requires it).
/// Converts all images to JPEG format which FFmpeg min_gpl can decode.
Future<List<String>> compressImagesWorker(CompressionArgs args) async {
  final processedPaths = <String>[];

  for (int i = 0; i < args.imagePaths.length; i++) {
    final imagePath = args.imagePaths[i];
    final outputPath = p.join(
      args.tempDirPath,
      'photo_sequence_${i}_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    try {
      final result = await FlutterImageCompress.compressAndGetFile(
        imagePath,
        outputPath,
        minWidth: args.maxDimension,
        minHeight: args.maxDimension,
        quality: args.quality,
        keepExif: false,
        format: CompressFormat.jpeg,
      );

      if (result != null) {
        processedPaths.add(result.path);
        print('Compressed: $imagePath -> ${result.path}');
      } else {
        print('Compression returned null for $imagePath, trying fallback');
        // Try fallback compression
        final fallbackPath = await _fallbackConversion(
          imagePath,
          outputPath,
          args.quality,
        );
        if (fallbackPath != null) {
          processedPaths.add(fallbackPath);
        } else {
          print('Fallback also failed for $imagePath');
        }
      }
    } catch (e) {
      print('Compression error for $imagePath: $e');
      // Try fallback compression
      final fallbackPath = await _fallbackConversion(
        imagePath,
        outputPath,
        args.quality,
      );
      if (fallbackPath != null) {
        processedPaths.add(fallbackPath);
      } else {
        print('Fallback also failed for $imagePath');
      }
    }
  }

  return processedPaths;
}

/// Fallback conversion using Dart's image codec to ensure JPEG output.
Future<String?> _fallbackConversion(
  String inputPath,
  String outputPath,
  int quality,
) async {
  try {
    final inputFile = File(inputPath);
    final bytes = await inputFile.readAsBytes();

    // Decode image
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    // Convert to byte data
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return null;

    // Re-compress as JPEG using flutter_image_compress with memory API
    final result = await FlutterImageCompress.compressWithList(
      byteData.buffer.asUint8List(),
      quality: quality,
      format: CompressFormat.jpeg,
    );

    // Save to file
    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(result);

    print('Fallback conversion successful: $inputPath -> $outputPath');
    return outputPath;
  } catch (e) {
    print('Fallback conversion error: $e');
    return null;
  }
}
