import 'dart:io';

/// Interface for picking media files (photos and audio).
abstract interface class IMediaRepository {
  /// Pick multiple photos from gallery.
  Future<List<File>> pickPhotos({int maxImages = 5});

  /// Pick a single audio file for background music.
  Future<File?> pickAudio();

  /// Check if we have enough photos selected.
  bool hasMinimumPhotos(List<File> photos);

  /// Check if we have the maximum photos selected.
  bool hasMaximumPhotos(List<File> photos);
}
