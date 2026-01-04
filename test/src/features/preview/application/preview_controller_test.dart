import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:photo_sequence/src/features/home/domain/photo_sequence_project.dart';
import 'package:photo_sequence/src/features/home/domain/transition_type.dart';
import 'package:photo_sequence/src/features/preview/application/preview_controller.dart';

void main() {
  // Create mock files for testing
  File mockFile(String name) => File('/mock/$name');

  late PhotoSequenceProject project3Images;
  late PhotoSequenceProject project5Images;

  setUp(() {
    project3Images = PhotoSequenceProject(
      photos: [mockFile('1.jpg'), mockFile('2.jpg'), mockFile('3.jpg')],
      imageDuration: const Duration(seconds: 3),
      transitionDuration: const Duration(seconds: 1),
      transitionType: TransitionType.dissolve,
    );

    project5Images = PhotoSequenceProject(
      photos: [
        mockFile('1.jpg'),
        mockFile('2.jpg'),
        mockFile('3.jpg'),
        mockFile('4.jpg'),
        mockFile('5.jpg'),
      ],
      imageDuration: const Duration(seconds: 3),
      transitionDuration: const Duration(seconds: 1),
      transitionType: TransitionType.slideLeft,
    );
  });

  group('PreviewController', () {
    group('constructor', () {
      test('initializes with project', () {
        final controller = PreviewController(project3Images);
        expect(controller.project, project3Images);
        addTearDown(controller.dispose);
      });

      test('isPlaying is false initially', () {
        final controller = PreviewController(project3Images);
        expect(controller.isPlaying, false);
        addTearDown(controller.dispose);
      });

      test('progress is 0 without initialization', () {
        final controller = PreviewController(project3Images);
        expect(controller.progress, 0);
        addTearDown(controller.dispose);
      });
    });

    group('totalDurationSeconds', () {
      test('returns correct duration for 3 images', () {
        final controller = PreviewController(project3Images);
        // 3 × 3s - 2 × 1s = 7 seconds
        expect(controller.totalDurationSeconds, 7.0);
        addTearDown(controller.dispose);
      });

      test('returns correct duration for 5 images', () {
        final controller = PreviewController(project5Images);
        // 5 × 3s - 4 × 1s = 11 seconds
        expect(controller.totalDurationSeconds, 11.0);
        addTearDown(controller.dispose);
      });
    });

    group('currentTimeSeconds', () {
      test('returns 0 when controller not initialized', () {
        final controller = PreviewController(project3Images);
        expect(controller.currentTimeSeconds, 0.0);
        addTearDown(controller.dispose);
      });
    });

    group('getImageOpacityAtTime (dissolve transition)', () {
      late PreviewController controller;

      setUp(() {
        controller = PreviewController(project3Images);
      });

      tearDown(() {
        controller.dispose();
      });

      test('first image fully visible at t=0', () {
        expect(controller.getImageOpacityAtTime(0, 0.0), 1.0);
      });

      test('first image fully visible at t=1 (before fade out)', () {
        expect(controller.getImageOpacityAtTime(0, 1.0), 1.0);
      });

      test('first image fading out at t=2.5', () {
        // Fade out starts at 2.0, ends at 3.0
        final opacity = controller.getImageOpacityAtTime(0, 2.5);
        expect(opacity, closeTo(0.5, 0.01));
      });

      test('first image invisible at t=3.0 (after window)', () {
        expect(controller.getImageOpacityAtTime(0, 3.1), 0.0);
      });

      test('second image invisible before its window', () {
        expect(controller.getImageOpacityAtTime(1, 1.0), 0.0);
      });

      test('second image fading in at t=2.5', () {
        // Window starts at 2.0, fade in ends at 3.0
        final opacity = controller.getImageOpacityAtTime(1, 2.5);
        expect(opacity, closeTo(0.5, 0.01));
      });

      test('second image fully visible at t=3.5', () {
        expect(controller.getImageOpacityAtTime(1, 3.5), 1.0);
      });

      test('last image fully visible at end (no fade out)', () {
        expect(controller.getImageOpacityAtTime(2, 6.5), 1.0);
      });

      test('returns 0 for invalid index (negative)', () {
        expect(controller.getImageOpacityAtTime(-1, 1.0), 0.0);
      });

      test('returns 0 for invalid index (out of bounds)', () {
        expect(controller.getImageOpacityAtTime(10, 1.0), 0.0);
      });
    });

    group('getImageOffsetAtTime (slide transitions)', () {
      late PreviewController controller;

      setUp(() {
        controller = PreviewController(project5Images);
      });

      tearDown(() {
        controller.dispose();
      });

      test('first image at origin at t=0', () {
        expect(controller.getImageOffsetAtTime(0, 0.0), Offset.zero);
      });

      test('first image slides out left during transition', () {
        // Window ends at 3.0, slide out from 2.0 to 3.0
        final offset = controller.getImageOffsetAtTime(0, 2.5);
        // Should be sliding left (negative x)
        expect(offset.dx, lessThan(0));
        expect(offset.dx, closeTo(-0.5, 0.01));
        expect(offset.dy, 0.0);
      });

      test('second image slides in from right', () {
        // Window starts at 2.0, slide in from 2.0 to 3.0
        final offset = controller.getImageOffsetAtTime(1, 2.5);
        // Should be partially slid in (positive x decreasing)
        expect(offset.dx, closeTo(0.5, 0.01));
        expect(offset.dy, 0.0);
      });

      test('second image at origin after slide in', () {
        expect(controller.getImageOffsetAtTime(1, 3.5), Offset.zero);
      });

      test('returns offset for invalid index (out of bounds)', () {
        final offset = controller.getImageOffsetAtTime(10, 1.0);
        expect(offset, const Offset(1, 0)); // Off screen right
      });
    });

    group('getImageOffsetAtTime (different transition types)', () {
      test('slideRight slides from left', () {
        final project = PhotoSequenceProject(
          photos: [mockFile('1.jpg'), mockFile('2.jpg'), mockFile('3.jpg')],
          transitionType: TransitionType.slideRight,
          imageDuration: const Duration(seconds: 3),
          transitionDuration: const Duration(seconds: 1),
        );
        final controller = PreviewController(project);

        // Second image slides in from left
        final offset = controller.getImageOffsetAtTime(1, 2.0);
        expect(offset.dx, lessThan(0)); // Starts from left
        expect(offset.dy, 0.0);

        addTearDown(controller.dispose);
      });

      test('slideUp slides from bottom', () {
        final project = PhotoSequenceProject(
          photos: [mockFile('1.jpg'), mockFile('2.jpg'), mockFile('3.jpg')],
          transitionType: TransitionType.slideUp,
          imageDuration: const Duration(seconds: 3),
          transitionDuration: const Duration(seconds: 1),
        );
        final controller = PreviewController(project);

        // Second image slides in from bottom
        final offset = controller.getImageOffsetAtTime(1, 2.0);
        expect(offset.dx, 0.0);
        expect(offset.dy, greaterThan(0)); // Starts from bottom

        addTearDown(controller.dispose);
      });

      test('slideDown slides from top', () {
        final project = PhotoSequenceProject(
          photos: [mockFile('1.jpg'), mockFile('2.jpg'), mockFile('3.jpg')],
          transitionType: TransitionType.slideDown,
          imageDuration: const Duration(seconds: 3),
          transitionDuration: const Duration(seconds: 1),
        );
        final controller = PreviewController(project);

        // Second image slides in from top
        final offset = controller.getImageOffsetAtTime(1, 2.0);
        expect(offset.dx, 0.0);
        expect(offset.dy, lessThan(0)); // Starts from top

        addTearDown(controller.dispose);
      });

      test('dissolve returns zero offset', () {
        final project = PhotoSequenceProject(
          photos: [mockFile('1.jpg'), mockFile('2.jpg'), mockFile('3.jpg')],
          transitionType: TransitionType.dissolve,
          imageDuration: const Duration(seconds: 3),
          transitionDuration: const Duration(seconds: 1),
        );
        final controller = PreviewController(project);

        expect(controller.getImageOffsetAtTime(0, 1.0), Offset.zero);
        expect(controller.getImageOffsetAtTime(1, 2.5), Offset.zero);

        addTearDown(controller.dispose);
      });
    });

    group('isImageVisible', () {
      late PreviewController controller;

      setUp(() {
        controller = PreviewController(project3Images);
      });

      tearDown(() {
        controller.dispose();
      });

      test('returns false for invalid index', () {
        expect(controller.isImageVisible(-1), false);
        expect(controller.isImageVisible(10), false);
      });
    });
  });
}
