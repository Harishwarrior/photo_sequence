import 'dart:io';

import 'package:equatable/equatable.dart';

import 'export_settings.dart';
import 'transition_type.dart';

/// Represents a photo sequence project with all configuration.
class PhotoSequenceProject extends Equatable {
  /// List of photos to include (3-5 photos)
  final List<File> photos;

  /// Optional background music file
  final File? backgroundMusic;

  /// Type of transition between photos
  final TransitionType transitionType;

  /// How long each image is displayed
  final Duration imageDuration;

  /// Duration of the transition effect
  final Duration transitionDuration;

  /// Export settings for final video
  final ExportSettings exportSettings;

  const PhotoSequenceProject({
    required this.photos,
    this.backgroundMusic,
    this.transitionType = TransitionType.dissolve,
    this.imageDuration = const Duration(seconds: 3),
    this.transitionDuration = const Duration(seconds: 1),
    this.exportSettings = ExportSettings.hd720,
  });

  /// Total duration of the sequence.
  ///
  /// Formula: (N × D_img) - ((N-1) × D_trans)
  /// Example: 3 images × 3s - 2 transitions × 1s = 7 seconds
  Duration get totalDuration {
    if (photos.isEmpty) return Duration.zero;
    final imageMs = imageDuration.inMilliseconds * photos.length;
    final transitionMs =
        transitionDuration.inMilliseconds * (photos.length - 1);
    return Duration(milliseconds: imageMs - transitionMs);
  }

  /// Total duration in seconds as double
  double get totalDurationSeconds => totalDuration.inMilliseconds / 1000.0;

  /// Image duration in seconds as double
  double get imageDurationSeconds => imageDuration.inMilliseconds / 1000.0;

  /// Transition duration in seconds as double
  double get transitionDurationSeconds =>
      transitionDuration.inMilliseconds / 1000.0;

  /// Whether the project is valid for export (3-5 photos)
  bool get isValid => photos.length >= 3 && photos.length <= 5;

  /// Create a copy with updated values
  PhotoSequenceProject copyWith({
    List<File>? photos,
    File? backgroundMusic,
    bool clearBackgroundMusic = false,
    TransitionType? transitionType,
    Duration? imageDuration,
    Duration? transitionDuration,
    ExportSettings? exportSettings,
  }) {
    return PhotoSequenceProject(
      photos: photos ?? this.photos,
      backgroundMusic: clearBackgroundMusic
          ? null
          : (backgroundMusic ?? this.backgroundMusic),
      transitionType: transitionType ?? this.transitionType,
      imageDuration: imageDuration ?? this.imageDuration,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      exportSettings: exportSettings ?? this.exportSettings,
    );
  }

  @override
  List<Object?> get props => [
    photos,
    backgroundMusic,
    transitionType,
    imageDuration,
    transitionDuration,
    exportSettings,
  ];
}
