import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../home/domain/photo_sequence_project.dart';
import '../../home/domain/transition_type.dart';
import '../../../core/utils/duration_calculator.dart';

/// Controller for managing preview playback of photo sequences.
///
/// Implements the Master Controller Pattern from the engineering spec:
/// - Single AnimationController drives all transitions
/// - Audio playback synchronized with animation
/// - Exposes current time, opacity, and offset calculations
class PreviewController extends ChangeNotifier {
  PreviewController(this.project) {
    _initializeTimeWindows();
  }

  final PhotoSequenceProject project;
  AnimationController? _masterController;
  AudioPlayer? _audioPlayer;
  bool _isPlaying = false;
  bool _isAudioInitialized = false;

  List<({double startTime, double endTime})> _timeWindows = [];

  bool get isPlaying => _isPlaying;
  double get totalDurationSeconds => project.totalDurationSeconds;

  /// Current time in seconds based on animation controller
  double get currentTimeSeconds {
    if (_masterController == null) return 0;
    return _masterController!.value * totalDurationSeconds;
  }

  /// Current progress (0.0 to 1.0)
  double get progress => _masterController?.value ?? 0;

  /// Initialize with a TickerProvider
  void initialize(TickerProvider vsync) {
    _masterController = AnimationController(
      vsync: vsync,
      duration: Duration(milliseconds: project.totalDuration.inMilliseconds),
    );

    _masterController!.addListener(() {
      notifyListeners();
    });

    _masterController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _isPlaying = false;
        _audioPlayer?.stop();
        notifyListeners();
      }
    });

    _initAudio();
  }

  void _initializeTimeWindows() {
    _timeWindows = DurationCalculator.imageTimeWindows(
      imageCount: project.photos.length,
      imageDurationSec: project.imageDurationSeconds,
      transitionDurationSec: project.transitionDurationSeconds,
    );
  }

  Future<void> _initAudio() async {
    if (project.backgroundMusic != null) {
      _audioPlayer = AudioPlayer();
      try {
        await _audioPlayer!.setSource(
          DeviceFileSource(project.backgroundMusic!.path),
        );
        await _audioPlayer!.setReleaseMode(ReleaseMode.stop);
        _isAudioInitialized = true;
      } catch (e) {
        print('Error initializing audio: $e');
        // Audio init failed, continue without audio
        _isAudioInitialized = false;
      }
    }
  }

  /// Play the preview from current position
  Future<void> play() async {
    if (_masterController == null) return;

    if (_masterController!.status == AnimationStatus.completed) {
      _masterController!.reset();
      if (_isAudioInitialized && _audioPlayer != null) {
        await _audioPlayer!.seek(Duration.zero);
      }
    }

    _isPlaying = true;
    _masterController!.forward();

    if (_isAudioInitialized && _audioPlayer != null) {
      await _audioPlayer!.seek(
        Duration(milliseconds: (currentTimeSeconds * 1000).round()),
      );
      await _audioPlayer!.resume();
    }

    notifyListeners();
  }

  /// Pause the preview
  Future<void> pause() async {
    if (_masterController == null) return;

    _isPlaying = false;
    _masterController!.stop();

    if (_isAudioInitialized && _audioPlayer != null) {
      await _audioPlayer!.pause();
    }

    notifyListeners();
  }

  /// Toggle play/pause
  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await pause();
    } else {
      await play();
    }
  }

  /// Seek to a specific time
  Future<void> seekTo(double timeSeconds) async {
    if (_masterController == null) return;

    final value = DurationCalculator.timeToControllerValue(
      timeSeconds,
      totalDurationSeconds,
    );
    _masterController!.value = value;

    if (_isAudioInitialized && _audioPlayer != null) {
      await _audioPlayer!.seek(
        Duration(milliseconds: (timeSeconds * 1000).round()),
      );
    }

    notifyListeners();
  }

  /// Seek to a progress value (0.0 to 1.0)
  Future<void> seekToProgress(double progress) async {
    if (_masterController == null) return;

    _masterController!.value = progress.clamp(0.0, 1.0);

    final timeMs = (progress * totalDurationSeconds * 1000).round();
    if (_isAudioInitialized && _audioPlayer != null) {
      await _audioPlayer!.seek(Duration(milliseconds: timeMs));
    }

    notifyListeners();
  }

  /// Reset to beginning
  Future<void> reset() async {
    if (_masterController == null) return;

    _isPlaying = false;
    _masterController!.reset();

    if (_isAudioInitialized && _audioPlayer != null) {
      await _audioPlayer!.stop();
      await _audioPlayer!.seek(Duration.zero);
    }

    notifyListeners();
  }

  /// Get opacity for an image at the current time.
  ///
  /// Used for dissolve transition.
  /// Returns 1.0 when fully visible, 0.0 when invisible,
  /// and interpolated values during transitions.
  double getImageOpacity(int imageIndex) {
    final currentTime = currentTimeSeconds;
    return getImageOpacityAtTime(imageIndex, currentTime);
  }

  /// Get opacity for an image at a specific time.
  double getImageOpacityAtTime(int imageIndex, double time) {
    if (imageIndex < 0 || imageIndex >= _timeWindows.length) return 0;

    final window = _timeWindows[imageIndex];
    final transitionDuration = project.transitionDurationSeconds;

    // Before this image's time window
    if (time < window.startTime) return 0;

    // After this image's time window
    if (time > window.endTime) return 0;

    // During fade in (only for non-first images)
    if (imageIndex > 0) {
      final fadeInStart = window.startTime;
      final fadeInEnd = window.startTime + transitionDuration;

      if (time >= fadeInStart && time < fadeInEnd) {
        return (time - fadeInStart) / transitionDuration;
      }
    }

    // During fade out (only for non-last images)
    if (imageIndex < project.photos.length - 1) {
      final fadeOutStart = window.endTime - transitionDuration;
      final fadeOutEnd = window.endTime;

      if (time >= fadeOutStart && time <= fadeOutEnd) {
        return 1.0 - ((time - fadeOutStart) / transitionDuration);
      }
    }

    // Fully visible
    return 1.0;
  }

  /// Get slide offset for an image at the current time.
  ///
  /// Used for slide transitions.
  /// Returns Offset.zero when in position, and offset values
  /// for sliding in/out of frame.
  Offset getImageOffset(int imageIndex) {
    final currentTime = currentTimeSeconds;
    return getImageOffsetAtTime(imageIndex, currentTime);
  }

  /// Get slide offset for an image at a specific time.
  Offset getImageOffsetAtTime(int imageIndex, double time) {
    if (imageIndex < 0 || imageIndex >= _timeWindows.length) {
      return const Offset(1, 0); // Off screen right
    }

    final window = _timeWindows[imageIndex];
    final transitionDuration = project.transitionDurationSeconds;
    final transitionType = project.transitionType;

    // Determine slide direction
    final Offset slideInFrom;
    final Offset slideOutTo;

    switch (transitionType) {
      case TransitionType.slideLeft:
        slideInFrom = const Offset(1, 0); // From right
        slideOutTo = const Offset(-1, 0); // To left
      case TransitionType.slideRight:
        slideInFrom = const Offset(-1, 0); // From left
        slideOutTo = const Offset(1, 0); // To right
      case TransitionType.slideUp:
        slideInFrom = const Offset(0, 1); // From bottom
        slideOutTo = const Offset(0, -1); // To top
      case TransitionType.slideDown:
        slideInFrom = const Offset(0, -1); // From top
        slideOutTo = const Offset(0, 1); // To bottom
      default:
        return Offset.zero; // No offset for dissolve
    }

    // Before this image's time window
    if (time < window.startTime) return slideInFrom;

    // After this image's time window
    if (time > window.endTime) return slideOutTo;

    // During slide in (only for non-first images)
    if (imageIndex > 0) {
      final slideInStart = window.startTime;
      final slideInEnd = window.startTime + transitionDuration;

      if (time >= slideInStart && time < slideInEnd) {
        final progress = (time - slideInStart) / transitionDuration;
        return Offset.lerp(slideInFrom, Offset.zero, progress)!;
      }
    }

    // During slide out (only for non-last images)
    if (imageIndex < project.photos.length - 1) {
      final slideOutStart = window.endTime - transitionDuration;
      final slideOutEnd = window.endTime;

      if (time >= slideOutStart && time <= slideOutEnd) {
        final progress = (time - slideOutStart) / transitionDuration;
        return Offset.lerp(Offset.zero, slideOutTo, progress)!;
      }
    }

    // In position
    return Offset.zero;
  }

  /// Check if an image should be visible at current time
  bool isImageVisible(int imageIndex) {
    if (imageIndex < 0 || imageIndex >= _timeWindows.length) return false;

    final window = _timeWindows[imageIndex];
    final currentTime = currentTimeSeconds;

    return currentTime >= window.startTime && currentTime <= window.endTime;
  }

  @override
  void dispose() {
    _masterController?.dispose();
    _audioPlayer?.dispose();
    super.dispose();
  }
}
