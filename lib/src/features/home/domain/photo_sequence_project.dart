import 'dart:io';
import 'package:json_annotation/json_annotation.dart';
import '../../../core/utils/json_converters.dart';
import 'export_settings.dart';
import 'transition_type.dart';

part 'photo_sequence_project.g.dart';

/// Represents a photo sequence project with all configuration.
@JsonSerializable()
@FileConverter()
class PhotoSequenceProject {
  /// List of photos to include (3-5 photos)
  final List<File> photos;

  /// Optional background music file
  @NullableFileConverter()
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
  Duration get totalDuration {
    if (photos.isEmpty) return Duration.zero;
    final imageMs = imageDuration.inMilliseconds * photos.length;
    final transitionMs =
        transitionDuration.inMilliseconds * (photos.length - 1);
    return Duration(milliseconds: imageMs - transitionMs);
  }

  double get totalDurationSeconds => totalDuration.inMilliseconds / 1000.0;
  double get imageDurationSeconds => imageDuration.inMilliseconds / 1000.0;
  double get transitionDurationSeconds =>
      transitionDuration.inMilliseconds / 1000.0;

  bool get isValid => photos.length >= 3 && photos.length <= 5;

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

  factory PhotoSequenceProject.fromJson(Map<String, dynamic> json) =>
      _$PhotoSequenceProjectFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoSequenceProjectToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhotoSequenceProject &&
          runtimeType == other.runtimeType &&
          _listEquals(photos, other.photos) &&
          backgroundMusic?.path == other.backgroundMusic?.path &&
          transitionType == other.transitionType &&
          imageDuration == other.imageDuration &&
          transitionDuration == other.transitionDuration &&
          exportSettings == other.exportSettings;

  @override
  int get hashCode =>
      photos.hashCode ^
      backgroundMusic.hashCode ^
      transitionType.hashCode ^
      imageDuration.hashCode ^
      transitionDuration.hashCode ^
      exportSettings.hashCode;

  bool _listEquals(List<File> a, List<File> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].path != b[i].path) return false;
    }
    return true;
  }
}
