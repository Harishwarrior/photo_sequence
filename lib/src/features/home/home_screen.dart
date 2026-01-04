import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/models/export_settings.dart';
import '../../core/models/photo_sequence_project.dart';
import '../../core/models/transition_type.dart';
import '../../core/services/media_repository.dart';
import '../export/export_screen.dart';
import '../preview/preview_screen.dart';

/// Home screen for photo selection and project configuration.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MediaRepository _mediaRepository = MediaRepository();

  List<File> _selectedPhotos = [];
  File? _backgroundMusic;
  TransitionType _transitionType = TransitionType.dissolve;
  Duration _imageDuration = const Duration(seconds: 3);
  Duration _transitionDuration = const Duration(seconds: 1);
  bool _isPicking = false;

  bool get _canPreview => _selectedPhotos.length >= 3;

  PhotoSequenceProject get _currentProject => PhotoSequenceProject(
    photos: _selectedPhotos,
    backgroundMusic: _backgroundMusic,
    transitionType: _transitionType,
    imageDuration: _imageDuration,
    transitionDuration: _transitionDuration,
    exportSettings: ExportSettings.hd720,
  );

  Future<void> _pickPhotos() async {
    if (_isPicking) return;

    final maxToSelect = 5 - _selectedPhotos.length;
    if (maxToSelect <= 0) return;

    setState(() {
      _isPicking = true;
    });

    try {
      final photos = await _mediaRepository.pickPhotos(maxImages: maxToSelect);
      if (photos.isNotEmpty) {
        setState(() {
          _selectedPhotos.addAll(photos);
          if (_selectedPhotos.length > 5) {
            _selectedPhotos = _selectedPhotos.sublist(0, 5);
          }
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPicking = false;
        });
      }
    }
  }

  Future<void> _pickMusic() async {
    if (_isPicking) return;

    setState(() {
      _isPicking = true;
    });

    try {
      final audio = await _mediaRepository.pickAudio();
      if (audio != null) {
        setState(() {
          _backgroundMusic = audio;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPicking = false;
        });
      }
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _selectedPhotos.removeAt(index);
    });
  }

  void _reorderPhotos(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final item = _selectedPhotos.removeAt(oldIndex);
      _selectedPhotos.insert(newIndex, item);
    });
  }

  void _clearMusic() {
    setState(() {
      _backgroundMusic = null;
    });
  }

  void _setTransitionType(TransitionType type) {
    setState(() {
      _transitionType = type;
    });
  }

  void _setImageDuration(Duration duration) {
    setState(() {
      _imageDuration = duration;
    });
  }

  void _setTransitionDuration(Duration duration) {
    setState(() {
      _transitionDuration = duration;
    });
  }

  Future<void> _openPreview() async {
    if (!_canPreview) return;

    final shouldExport = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => PreviewScreen(project: _currentProject),
      ),
    );

    if (shouldExport == true && mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ExportScreen(project: _currentProject),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        title: const Text('Photo Sequence'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PhotoSection(
              photos: _selectedPhotos,
              isLoading: _isPicking,
              onPickPhotos: _pickPhotos,
              onRemovePhoto: _removePhoto,
              onReorder: _reorderPhotos,
            ),
            const SizedBox(height: 24),
            MusicSection(
              backgroundMusic: _backgroundMusic,
              isLoading: _isPicking,
              onPickMusic: _pickMusic,
              onClearMusic: _clearMusic,
            ),
            const SizedBox(height: 24),
            SettingsSection(
              transitionType: _transitionType,
              imageDuration: _imageDuration,
              transitionDuration: _transitionDuration,
              onTransitionTypeChanged: _setTransitionType,
              onImageDurationChanged: _setImageDuration,
              onTransitionDurationChanged: _setTransitionDuration,
            ),
            const SizedBox(height: 32),
            PreviewButton(
              canPreview: _canPreview,
              totalDurationSeconds: _currentProject.totalDuration.inSeconds,
              onPressed: _openPreview,
            ),
          ],
        ),
      ),
    );
  }
}

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
        color: const Color(0xFF1E1E1E),
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

/// Single photo thumbnail in the grid.
class PhotoThumbnail extends StatelessWidget {
  const PhotoThumbnail({
    super.key,
    required this.photo,
    required this.index,
    required this.onRemove,
  });

  final File photo;
  final int index;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return ReorderableDragStartListener(
      index: index,
      child: Container(
        width: 80,
        height: 80,
        margin: const EdgeInsets.only(right: 8),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                photo,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 14, color: Colors.white),
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Button to add more photos.
class AddPhotoButton extends StatelessWidget {
  const AddPhotoButton({
    super.key,
    required this.isDisabled,
    required this.isEmpty,
    required this.onTap,
  });

  final bool isDisabled;
  final bool isEmpty;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDisabled ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white24, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              color: isDisabled ? Colors.white24 : Colors.white54,
            ),
            const SizedBox(width: 8),
            Text(
              isEmpty ? 'Select Photos' : 'Add More',
              style: TextStyle(
                color: isDisabled ? Colors.white24 : Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Background music selection section.
class MusicSection extends StatelessWidget {
  const MusicSection({
    super.key,
    required this.backgroundMusic,
    required this.isLoading,
    required this.onPickMusic,
    required this.onClearMusic,
  });

  final File? backgroundMusic;
  final bool isLoading;
  final VoidCallback onPickMusic;
  final VoidCallback onClearMusic;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Background Music',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Optional audio track',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: backgroundMusic == null && !isLoading ? onPickMusic : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white54,
                      ),
                    )
                  : Icon(
                      backgroundMusic != null
                          ? Icons.music_note
                          : Icons.music_note_outlined,
                      color: backgroundMusic != null
                          ? Colors.green
                          : Colors.white54,
                    ),
              title: Text(
                isLoading
                    ? 'Loading...'
                    : backgroundMusic != null
                    ? backgroundMusic!.path.split('/').last
                    : 'Tap to select music',
                style: TextStyle(
                  color: backgroundMusic != null
                      ? Colors.white
                      : Colors.white54,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              trailing: backgroundMusic != null && !isLoading
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white54),
                          onPressed: onClearMusic,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.folder_open,
                            color: Colors.white54,
                          ),
                          onPressed: onPickMusic,
                        ),
                      ],
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}

/// Settings section for transition and duration configuration.
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.transitionType,
    required this.imageDuration,
    required this.transitionDuration,
    required this.onTransitionTypeChanged,
    required this.onImageDurationChanged,
    required this.onTransitionDurationChanged,
  });

  final TransitionType transitionType;
  final Duration imageDuration;
  final Duration transitionDuration;
  final void Function(TransitionType) onTransitionTypeChanged;
  final void Function(Duration) onImageDurationChanged;
  final void Function(Duration) onTransitionDurationChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TransitionTypeSetting(
                value: transitionType,
                onChanged: onTransitionTypeChanged,
              ),
              const Divider(color: Colors.white12),
              DurationSetting(
                label: 'Photo Duration',
                value: imageDuration,
                minSeconds: 2,
                maxSeconds: 10,
                stepMs: 1000,
                onChanged: onImageDurationChanged,
              ),
              const Divider(color: Colors.white12),
              DurationSetting(
                label: 'Transition Duration',
                value: transitionDuration,
                minSeconds: 0.5,
                maxSeconds: 2.0,
                stepMs: 500,
                onChanged: onTransitionDurationChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Transition type dropdown setting.
class TransitionTypeSetting extends StatelessWidget {
  const TransitionTypeSetting({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final TransitionType value;
  final void Function(TransitionType) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Transition', style: TextStyle(color: Colors.white)),
        DropdownButton<TransitionType>(
          value: value,
          dropdownColor: const Color(0xFF2A2A2A),
          style: const TextStyle(color: Colors.white),
          underline: const SizedBox(),
          items: TransitionType.values.map((type) {
            return DropdownMenuItem(value: type, child: Text(type.displayName));
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) onChanged(newValue);
          },
        ),
      ],
    );
  }
}

/// Duration setting with increment/decrement buttons.
class DurationSetting extends StatelessWidget {
  const DurationSetting({
    super.key,
    required this.label,
    required this.value,
    required this.minSeconds,
    required this.maxSeconds,
    required this.stepMs,
    required this.onChanged,
  });

  final String label;
  final Duration value;
  final double minSeconds;
  final double maxSeconds;
  final int stepMs;
  final void Function(Duration) onChanged;

  @override
  Widget build(BuildContext context) {
    final canDecrement = value.inMilliseconds > (minSeconds * 1000);
    final canIncrement = value.inMilliseconds < (maxSeconds * 1000);
    final displayValue = value.inMilliseconds / 1000;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove, color: Colors.white54),
              onPressed: canDecrement
                  ? () => onChanged(
                      Duration(milliseconds: value.inMilliseconds - stepMs),
                    )
                  : null,
            ),
            Text(
              '${displayValue}s',
              style: const TextStyle(color: Colors.white),
            ),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white54),
              onPressed: canIncrement
                  ? () => onChanged(
                      Duration(milliseconds: value.inMilliseconds + stepMs),
                    )
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}

/// Preview button at the bottom of home screen.
class PreviewButton extends StatelessWidget {
  const PreviewButton({
    super.key,
    required this.canPreview,
    required this.totalDurationSeconds,
    required this.onPressed,
  });

  final bool canPreview;
  final int totalDurationSeconds;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: canPreview ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        disabledBackgroundColor: Colors.white24,
        disabledForegroundColor: Colors.white54,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(canPreview ? Icons.play_arrow : Icons.photo_library_outlined),
          const SizedBox(width: 8),
          Text(
            canPreview
                ? 'Preview (${totalDurationSeconds}s)'
                : 'Select at least 3 photos',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
