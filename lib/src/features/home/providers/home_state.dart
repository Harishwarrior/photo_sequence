import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/export_settings.dart';
import '../../../core/models/photo_sequence_project.dart';
import '../../../core/models/transition_type.dart';
import '../../../core/services/media_repository.dart';

part 'home_state.freezed.dart';
part 'home_state.g.dart';

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

/// Provider for home screen state management.
@riverpod
class HomeNotifier extends _$HomeNotifier {
  final MediaRepository _mediaRepository = MediaRepository();

  @override
  HomeState build() => const HomeState();

  Future<void> pickPhotos() async {
    if (state.isPicking) return;

    final maxToSelect = 5 - state.photos.length;
    if (maxToSelect <= 0) return;

    state = state.copyWith(isPicking: true);

    try {
      final photos = await _mediaRepository.pickPhotos(maxImages: maxToSelect);
      if (photos.isNotEmpty) {
        var newPhotos = [...state.photos, ...photos];
        if (newPhotos.length > 5) {
          newPhotos = newPhotos.sublist(0, 5);
        }
        state = state.copyWith(photos: newPhotos);
      }
    } finally {
      state = state.copyWith(isPicking: false);
    }
  }

  Future<void> pickMusic() async {
    if (state.isPicking) return;

    state = state.copyWith(isPicking: true);

    try {
      final audio = await _mediaRepository.pickAudio();
      if (audio != null) {
        state = state.copyWith(backgroundMusic: audio);
      }
    } finally {
      state = state.copyWith(isPicking: false);
    }
  }

  void removePhoto(int index) {
    final newPhotos = [...state.photos];
    newPhotos.removeAt(index);
    state = state.copyWith(photos: newPhotos);
  }

  void reorderPhotos(int oldIndex, int newIndex) {
    final newPhotos = [...state.photos];
    if (newIndex > oldIndex) newIndex--;
    final item = newPhotos.removeAt(oldIndex);
    newPhotos.insert(newIndex, item);
    state = state.copyWith(photos: newPhotos);
  }

  void clearMusic() {
    state = state.copyWith(backgroundMusic: null);
  }

  void setTransitionType(TransitionType type) {
    state = state.copyWith(transitionType: type);
  }

  void setImageDuration(Duration duration) {
    state = state.copyWith(imageDuration: duration);
  }

  void setTransitionDuration(Duration duration) {
    state = state.copyWith(transitionDuration: duration);
  }
}
