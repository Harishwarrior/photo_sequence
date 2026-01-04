import 'dart:io';

import 'package:flutter/material.dart';

import 'add_photo_button.dart';
import 'photo_thumbnail.dart';

/// Grid of selected photos with reorder and remove functionality.
class PhotoGrid extends StatelessWidget {
  const PhotoGrid({
    super.key,
    required this.photos,
    required this.isLoading,
    required this.onPickPhotos,
    required this.onRemovePhoto,
    required this.onReorder,
  });

  final List<File> photos;
  final bool isLoading;
  final VoidCallback onPickPhotos;
  final void Function(int index) onRemovePhoto;
  final void Function(int oldIndex, int newIndex) onReorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          if (photos.isNotEmpty) ...[
            SizedBox(
              height: 100,
              child: ReorderableListView.builder(
                scrollDirection: Axis.horizontal,
                buildDefaultDragHandles: false,
                itemCount: photos.length,
                onReorder: onReorder,
                itemBuilder: (context, index) {
                  return PhotoThumbnail(
                    key: Key('photo_$index'),
                    photo: photos[index],
                    index: index,
                    onRemove: () => onRemovePhoto(index),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white54,
                  ),
                ),
              ),
            )
          else
            AddPhotoButton(
              isDisabled: photos.length >= 5,
              isEmpty: photos.isEmpty,
              onTap: onPickPhotos,
            ),
        ],
      ),
    );
  }
}
