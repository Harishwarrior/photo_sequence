import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:photo_sequence/src/features/home/domain/export_settings.dart';
import 'package:photo_sequence/src/features/home/domain/photo_sequence_project.dart';
import 'package:photo_sequence/src/features/home/domain/transition_type.dart';

void main() {
  // Create mock files for testing (these don't need to exist on disk for unit tests)
  File mockFile(String name) => File('/mock/$name');

  group('PhotoSequenceProject', () {
    group('constructor', () {
      test('creates with required parameters', () {
        final project = PhotoSequenceProject(
          photos: [mockFile('1.jpg'), mockFile('2.jpg'), mockFile('3.jpg')],
        );

        expect(project.photos.length, 3);
        expect(project.backgroundMusic, isNull);
        expect(project.transitionType, TransitionType.dissolve);
        expect(project.imageDuration, const Duration(seconds: 3));
        expect(project.transitionDuration, const Duration(seconds: 1));
        expect(project.exportSettings, ExportSettings.hd720);
      });

      test('creates with all parameters', () {
        final music = mockFile('music.mp3');
        final project = PhotoSequenceProject(
          photos: [mockFile('1.jpg'), mockFile('2.jpg'), mockFile('3.jpg')],
          backgroundMusic: music,
          transitionType: TransitionType.slideLeft,
          imageDuration: const Duration(seconds: 5),
          transitionDuration: const Duration(seconds: 2),
          exportSettings: ExportSettings.hd1080,
        );

        expect(project.photos.length, 3);
        expect(project.backgroundMusic, music);
        expect(project.transitionType, TransitionType.slideLeft);
        expect(project.imageDuration, const Duration(seconds: 5));
        expect(project.transitionDuration, const Duration(seconds: 2));
        expect(project.exportSettings, ExportSettings.hd1080);
      });
    });

    group('isValid', () {
      test('returns false for empty photos', () {
        final project = PhotoSequenceProject(photos: []);
        expect(project.isValid, false);
      });

      test('returns false for 1 photo', () {
        final project = PhotoSequenceProject(photos: [mockFile('1.jpg')]);
        expect(project.isValid, false);
      });

      test('returns false for 2 photos', () {
        final project = PhotoSequenceProject(
          photos: [mockFile('1.jpg'), mockFile('2.jpg')],
        );
        expect(project.isValid, false);
      });

      test('returns true for 3 photos', () {
        final project = PhotoSequenceProject(
          photos: [mockFile('1.jpg'), mockFile('2.jpg'), mockFile('3.jpg')],
        );
        expect(project.isValid, true);
      });

      test('returns true for 4 photos', () {
        final project = PhotoSequenceProject(
          photos: [
            mockFile('1.jpg'),
            mockFile('2.jpg'),
            mockFile('3.jpg'),
            mockFile('4.jpg'),
          ],
        );
        expect(project.isValid, true);
      });

      test('returns true for 5 photos', () {
        final project = PhotoSequenceProject(
          photos: [
            mockFile('1.jpg'),
            mockFile('2.jpg'),
            mockFile('3.jpg'),
            mockFile('4.jpg'),
            mockFile('5.jpg'),
          ],
        );
        expect(project.isValid, true);
      });

      test('returns false for 6 photos', () {
        final project = PhotoSequenceProject(
          photos: [
            mockFile('1.jpg'),
            mockFile('2.jpg'),
            mockFile('3.jpg'),
            mockFile('4.jpg'),
            mockFile('5.jpg'),
            mockFile('6.jpg'),
          ],
        );
        expect(project.isValid, false);
      });
    });

    group('totalDuration', () {
      test('returns zero for empty photos', () {
        final project = PhotoSequenceProject(photos: []);
        expect(project.totalDuration, Duration.zero);
      });

      test('calculates correctly for 3 photos', () {
        // 3 images × 3s - 2 transitions × 1s = 7 seconds
        final project = PhotoSequenceProject(
          photos: [mockFile('1.jpg'), mockFile('2.jpg'), mockFile('3.jpg')],
          imageDuration: const Duration(seconds: 3),
          transitionDuration: const Duration(seconds: 1),
        );
        expect(project.totalDuration, const Duration(seconds: 7));
      });

      test('calculates correctly for 5 photos', () {
        // 5 images × 3s - 4 transitions × 1s = 11 seconds
        final project = PhotoSequenceProject(
          photos: [
            mockFile('1.jpg'),
            mockFile('2.jpg'),
            mockFile('3.jpg'),
            mockFile('4.jpg'),
            mockFile('5.jpg'),
          ],
          imageDuration: const Duration(seconds: 3),
          transitionDuration: const Duration(seconds: 1),
        );
        expect(project.totalDuration, const Duration(seconds: 11));
      });

      test('handles custom durations', () {
        // 4 images × 5s - 3 transitions × 2s = 14 seconds
        final project = PhotoSequenceProject(
          photos: [
            mockFile('1.jpg'),
            mockFile('2.jpg'),
            mockFile('3.jpg'),
            mockFile('4.jpg'),
          ],
          imageDuration: const Duration(seconds: 5),
          transitionDuration: const Duration(seconds: 2),
        );
        expect(project.totalDuration, const Duration(seconds: 14));
      });
    });

    group('duration getters', () {
      test('totalDurationSeconds returns correct value', () {
        final project = PhotoSequenceProject(
          photos: [mockFile('1.jpg'), mockFile('2.jpg'), mockFile('3.jpg')],
          imageDuration: const Duration(seconds: 3),
          transitionDuration: const Duration(seconds: 1),
        );
        expect(project.totalDurationSeconds, 7.0);
      });

      test('imageDurationSeconds returns correct value', () {
        final project = PhotoSequenceProject(
          photos: [mockFile('1.jpg'), mockFile('2.jpg'), mockFile('3.jpg')],
          imageDuration: const Duration(milliseconds: 2500),
        );
        expect(project.imageDurationSeconds, 2.5);
      });

      test('transitionDurationSeconds returns correct value', () {
        final project = PhotoSequenceProject(
          photos: [mockFile('1.jpg'), mockFile('2.jpg'), mockFile('3.jpg')],
          transitionDuration: const Duration(milliseconds: 1500),
        );
        expect(project.transitionDurationSeconds, 1.5);
      });
    });

    group('copyWith', () {
      late PhotoSequenceProject originalProject;

      setUp(() {
        originalProject = PhotoSequenceProject(
          photos: [mockFile('1.jpg'), mockFile('2.jpg'), mockFile('3.jpg')],
          backgroundMusic: mockFile('music.mp3'),
          transitionType: TransitionType.dissolve,
          imageDuration: const Duration(seconds: 3),
          transitionDuration: const Duration(seconds: 1),
          exportSettings: ExportSettings.hd720,
        );
      });

      test('returns copy with same values when no parameters provided', () {
        final copy = originalProject.copyWith();
        expect(copy.photos, originalProject.photos);
        expect(copy.backgroundMusic, originalProject.backgroundMusic);
        expect(copy.transitionType, originalProject.transitionType);
        expect(copy.imageDuration, originalProject.imageDuration);
        expect(copy.transitionDuration, originalProject.transitionDuration);
        expect(copy.exportSettings, originalProject.exportSettings);
      });

      test('updates photos', () {
        final newPhotos = [
          mockFile('a.jpg'),
          mockFile('b.jpg'),
          mockFile('c.jpg'),
        ];
        final copy = originalProject.copyWith(photos: newPhotos);
        expect(copy.photos, newPhotos);
        expect(copy.backgroundMusic, originalProject.backgroundMusic);
      });

      test('updates backgroundMusic', () {
        final newMusic = mockFile('new_music.mp3');
        final copy = originalProject.copyWith(backgroundMusic: newMusic);
        expect(copy.backgroundMusic, newMusic);
      });

      test('clears backgroundMusic when clearBackgroundMusic is true', () {
        final copy = originalProject.copyWith(clearBackgroundMusic: true);
        expect(copy.backgroundMusic, isNull);
      });

      test('clearBackgroundMusic takes precedence over new value', () {
        final copy = originalProject.copyWith(
          clearBackgroundMusic: true,
          backgroundMusic: mockFile('new.mp3'),
        );
        expect(copy.backgroundMusic, isNull);
      });

      test('updates transitionType', () {
        final copy = originalProject.copyWith(
          transitionType: TransitionType.slideUp,
        );
        expect(copy.transitionType, TransitionType.slideUp);
      });

      test('updates imageDuration', () {
        final copy = originalProject.copyWith(
          imageDuration: const Duration(seconds: 5),
        );
        expect(copy.imageDuration, const Duration(seconds: 5));
      });

      test('updates transitionDuration', () {
        final copy = originalProject.copyWith(
          transitionDuration: const Duration(seconds: 2),
        );
        expect(copy.transitionDuration, const Duration(seconds: 2));
      });

      test('updates exportSettings', () {
        final copy = originalProject.copyWith(
          exportSettings: ExportSettings.hd1080,
        );
        expect(copy.exportSettings, ExportSettings.hd1080);
      });
    });

    group('equality', () {
      test('two projects with same values are equal', () {
        final photos = [
          mockFile('1.jpg'),
          mockFile('2.jpg'),
          mockFile('3.jpg'),
        ];
        final project1 = PhotoSequenceProject(photos: photos);
        final project2 = PhotoSequenceProject(photos: photos);
        expect(project1, equals(project2));
      });

      test('two projects with different photos are not equal', () {
        final project1 = PhotoSequenceProject(
          photos: [mockFile('1.jpg'), mockFile('2.jpg'), mockFile('3.jpg')],
        );
        final project2 = PhotoSequenceProject(
          photos: [mockFile('a.jpg'), mockFile('b.jpg'), mockFile('c.jpg')],
        );
        expect(project1, isNot(equals(project2)));
      });

      test('two projects with different transition types are not equal', () {
        final photos = [
          mockFile('1.jpg'),
          mockFile('2.jpg'),
          mockFile('3.jpg'),
        ];
        final project1 = PhotoSequenceProject(
          photos: photos,
          transitionType: TransitionType.dissolve,
        );
        final project2 = PhotoSequenceProject(
          photos: photos,
          transitionType: TransitionType.slideLeft,
        );
        expect(project1, isNot(equals(project2)));
      });
    });
  });
}
