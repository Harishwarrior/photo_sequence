import 'package:gal/gal.dart';

/// Service for saving media to the device gallery.
///
/// Uses the `gal` package which properly handles:
/// - Android 13+ Scoped Storage APIs
/// - iOS Photo Library permissions
/// - Permission-less saving on Android 13+ for app-created content
class StorageService {
  /// Save a video file to the device gallery.
  ///
  /// Returns true if successful, false otherwise.
  Future<bool> saveVideoToGallery(String videoPath) async {
    try {
      await Gal.putVideo(videoPath);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Request gallery access permission if needed.
  ///
  /// On Android 13+, writing to gallery doesn't require permission
  /// if the app is the creator of the file.
  Future<bool> requestGalleryAccess() async {
    try {
      final hasAccess = await Gal.hasAccess();
      if (hasAccess) return true;

      return await Gal.requestAccess();
    } catch (e) {
      return false;
    }
  }

  /// Check if we have gallery access.
  Future<bool> hasGalleryAccess() async {
    try {
      return await Gal.hasAccess();
    } catch (e) {
      return false;
    }
  }
}
