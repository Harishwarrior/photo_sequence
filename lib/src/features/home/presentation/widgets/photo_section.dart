import 'dart:io';

import 'package:flutter/material.dart';

import 'photo_grid.dart';

/// Photo selection section with grid and add button.
class PhotoSection extends StatelessWidget {
  const PhotoSection({
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Photos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${photos.length}/5',
              style: TextStyle(
                color: photos.length >= 3 ? Colors.green : Colors.orange,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Select 3-5 photos for your video',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        PhotoGrid(
          photos: photos,
          isLoading: isLoading,
          onPickPhotos: onPickPhotos,
          onRemovePhoto: onRemovePhoto,
          onReorder: onReorder,
        ),
      ],
    );
  }
}
