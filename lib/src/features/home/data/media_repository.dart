import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/app_logger.dart';
import '../domain/repositories/i_media_repository.dart';

part 'media_repository.g.dart';

@riverpod
IMediaRepository mediaRepository(Ref ref) {
  return const MediaRepositoryImpl();
}

/// Implementation of the media repository using image_picker and file_picker.
class MediaRepositoryImpl implements IMediaRepository {
  const MediaRepositoryImpl();

  static final ImagePicker _imagePicker = ImagePicker();

  /// Pick multiple photos from gallery (3-5 recommended).
  ///
  /// Returns a list of File objects or empty list if cancelled.
  @override
  Future<List<File>> pickPhotos({int maxImages = 5}) async {
    try {
      if (maxImages <= 0) return [];

      // pickMultiImage requires limit >= 2. If 1, use pickImage.
      if (maxImages == 1) {
        final XFile? pickedFile = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 100,
        );
        return pickedFile != null ? [File(pickedFile.path)] : [];
      }

      final List<XFile> pickedFiles = await _imagePicker.pickMultiImage(
        limit: maxImages,
        imageQuality: 100,
      );

      if (pickedFiles.isEmpty) return [];

      return pickedFiles.map((xfile) => File(xfile.path)).toList();
    } catch (e) {
      // Handle permission denied or other errors
      AppLogger.e('Error picking photos: $e', e);
      return [];
    }
  }

  /// Pick a single audio file for background music.
  ///
  /// Returns the selected file or null if cancelled.
  /// Uses custom file type to avoid iOS Music Library iCloud caching issues.
  @override
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
      AppLogger.e('Error picking audio: $e', e);
      return null;
    }
  }

  /// Check if we have enough photos selected (minimum 3).
  @override
  bool hasMinimumPhotos(List<File> photos) => photos.length >= 3;

  /// Check if we have the maximum photos selected.
  @override
  bool hasMaximumPhotos(List<File> photos) => photos.length >= 5;
}
