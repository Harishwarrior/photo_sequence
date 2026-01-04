import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

/// Repository for picking media files (photos and audio).
class MediaRepository {
  final ImagePicker _imagePicker = ImagePicker();

  /// Pick multiple photos from gallery (3-5 recommended).
  ///
  /// Returns a list of File objects or empty list if cancelled.
  Future<List<File>> pickPhotos({int maxImages = 5}) async {
    try {
      final List<XFile> pickedFiles = await _imagePicker.pickMultiImage(
        limit: maxImages,
        imageQuality: 100,
      );

      if (pickedFiles.isEmpty) return [];

      return pickedFiles.map((xfile) => File(xfile.path)).toList();
    } catch (e) {
      // Handle permission denied or other errors
      print('Error picking photos: $e');
      return [];
    }
  }

  /// Pick a single audio file for background music.
  ///
  /// Returns the selected file or null if cancelled.
  /// Uses custom file type to avoid iOS Music Library iCloud caching issues.
  Future<File?> pickAudio() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'aac', 'm4a', 'wav', 'ogg', 'flac'],
        allowMultiple: false,
        withData: false,
        withReadStream: false,
      );

      if (result == null || result.files.isEmpty) return null;

      final path = result.files.first.path;
      if (path == null) return null;

      return File(path);
    } catch (e) {
      print('Error picking audio: $e');
      return null;
    }
  }

  /// Check if we have enough photos selected (minimum 3).
  bool hasMinimumPhotos(List<File> photos) => photos.length >= 3;

  /// Check if we have the maximum photos selected.
  bool hasMaximumPhotos(List<File> photos) => photos.length >= 5;
}
