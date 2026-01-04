/// Interface for saving and managing media in the device storage/gallery.
abstract interface class IStorageRepository {
  /// Save a video file to the device gallery.
  Future<bool> saveVideoToGallery(String videoPath);

  /// Request gallery access permission if needed.
  Future<bool> requestGalleryAccess();

  /// Check if we have gallery access.
  Future<bool> hasGalleryAccess();
}
