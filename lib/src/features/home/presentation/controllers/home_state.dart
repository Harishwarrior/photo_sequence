import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/export_settings.dart';
import '../../domain/photo_sequence_project.dart';
import '../../domain/transition_type.dart';

part 'home_state.freezed.dart';

/// State for the home screen.
@freezed
class HomeState with _$HomeState {
  const HomeState._();

  const factory HomeState({
    @Default([]) List<File> photos,
    File? backgroundMusic,
    @Default(TransitionType.dissolve) TransitionType transitionType,
    @Default(Duration(seconds: 3)) Duration imageDuration,
    @Default(Duration(seconds: 1)) Duration transitionDuration,
    @Default(false) bool isPicking,
  }) = _HomeState;

  bool get canPreview => photos.length >= 3;

  PhotoSequenceProject get project => PhotoSequenceProject(
    photos: photos,
    backgroundMusic: backgroundMusic,
    transitionType: transitionType,
    imageDuration: imageDuration,
    transitionDuration: transitionDuration,
    exportSettings: ExportSettings.hd720,
  );
}
