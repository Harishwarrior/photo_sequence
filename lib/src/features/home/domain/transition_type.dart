/// Transition types supported for photo sequences.
///
/// Each transition type maps to an FFmpeg xfade filter value.
enum TransitionType {
  /// Crossfade/dissolve effect between images
  dissolve('fade'),

  /// Slide left transition
  slideLeft('slideleft'),

  /// Slide right transition
  slideRight('slideright'),

  /// Slide up transition
  slideUp('slideup'),

  /// Slide down transition
  slideDown('slidedown');

  /// The FFmpeg xfade filter transition value
  final String ffmpegValue;

  const TransitionType(this.ffmpegValue);

  /// Display name for UI
  String get displayName {
    switch (this) {
      case TransitionType.dissolve:
        return 'Dissolve';
      case TransitionType.slideLeft:
        return 'Slide Left';
      case TransitionType.slideRight:
        return 'Slide Right';
      case TransitionType.slideUp:
        return 'Slide Up';
      case TransitionType.slideDown:
        return 'Slide Down';
    }
  }
}
