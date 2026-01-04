import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gal/gal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/repositories/i_storage_repository.dart';

part 'storage_repository.g.dart';

@riverpod
IStorageRepository storageRepository(Ref ref) {
  return const StorageRepositoryImpl();
}

/// Implementation of the storage repository using the `gal` package.
class StorageRepositoryImpl implements IStorageRepository {
  const StorageRepositoryImpl();

  @override
  Future<bool> saveVideoToGallery(String videoPath) async {
    try {
      await Gal.putVideo(videoPath);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> requestGalleryAccess() async {
    try {
      final hasAccess = await Gal.hasAccess();
      if (hasAccess) return true;

      return await Gal.requestAccess();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> hasGalleryAccess() async {
    try {
      return await Gal.hasAccess();
    } catch (e) {
      return false;
    }
  }
}
