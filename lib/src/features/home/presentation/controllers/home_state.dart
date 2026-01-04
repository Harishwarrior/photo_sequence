import 'dart:io';
import 'package:json_annotation/json_annotation.dart';
import '../../../../core/utils/json_converters.dart';
import '../../domain/export_settings.dart';
import '../../domain/photo_sequence_project.dart';
import '../../domain/transition_type.dart';

part 'home_state.g.dart';

@JsonSerializable()
@FileConverter()
class HomeState {
  final List<File> photos;

  @NullableFileConverter()
  final File? backgroundMusic;

  final TransitionType transitionType;
  final Duration imageDuration;
  final Duration transitionDuration;
  final bool isPicking;

  const HomeState({
    this.photos = const [],
    this.backgroundMusic,
    this.transitionType = TransitionType.dissolve,
    this.imageDuration = const Duration(seconds: 3),
    this.transitionDuration = const Duration(seconds: 1),
    this.isPicking = false,
  });

  bool get canPreview => photos.length >= 3;

  PhotoSequenceProject get project => PhotoSequenceProject(
    photos: photos,
    backgroundMusic: backgroundMusic,
    transitionType: transitionType,
    imageDuration: imageDuration,
    transitionDuration: transitionDuration,
    exportSettings: ExportSettings.hd720,
  );

  HomeState copyWith({
    List<File>? photos,
    File? backgroundMusic,
    TransitionType? transitionType,
    Duration? imageDuration,
    Duration? transitionDuration,
    bool? isPicking,
  }) {
    return HomeState(
      photos: photos ?? this.photos,
      backgroundMusic: backgroundMusic ?? this.backgroundMusic,
      transitionType: transitionType ?? this.transitionType,
      imageDuration: imageDuration ?? this.imageDuration,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      isPicking: isPicking ?? this.isPicking,
    );
  }

  factory HomeState.fromJson(Map<String, dynamic> json) =>
      _$HomeStateFromJson(json);

  Map<String, dynamic> toJson() => _$HomeStateToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeState &&
          runtimeType == other.runtimeType &&
          _listEquals(photos, other.photos) &&
          backgroundMusic?.path == other.backgroundMusic?.path &&
          transitionType == other.transitionType &&
          imageDuration == other.imageDuration &&
          transitionDuration == other.transitionDuration &&
          isPicking == other.isPicking;

  @override
  int get hashCode =>
      photos.hashCode ^
      backgroundMusic.hashCode ^
      transitionType.hashCode ^
      imageDuration.hashCode ^
      transitionDuration.hashCode ^
      isPicking.hashCode;

  bool _listEquals(List<File> a, List<File> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].path != b[i].path) return false;
    }
    return true;
  }
}
