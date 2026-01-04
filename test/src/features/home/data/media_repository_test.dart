import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:photo_sequence/src/features/home/data/media_repository.dart';

void main() {
  late MediaRepositoryImpl repository;

  // Create mock files for testing
  File mockFile(String name) => File('/mock/$name');

  setUp(() {
    repository = const MediaRepositoryImpl();
  });

  group('MediaRepository', () {
    group('hasMinimumPhotos', () {
      test('returns false for empty list', () {
        expect(repository.hasMinimumPhotos([]), false);
      });

      test('returns false for 1 photo', () {
        expect(repository.hasMinimumPhotos([mockFile('1.jpg')]), false);
      });

      test('returns false for 2 photos', () {
        expect(
          repository.hasMinimumPhotos([mockFile('1.jpg'), mockFile('2.jpg')]),
          false,
        );
      });

      test('returns true for 3 photos (minimum)', () {
        expect(
          repository.hasMinimumPhotos([
            mockFile('1.jpg'),
            mockFile('2.jpg'),
            mockFile('3.jpg'),
          ]),
          true,
        );
      });

      test('returns true for 4 photos', () {
        expect(
          repository.hasMinimumPhotos([
            mockFile('1.jpg'),
            mockFile('2.jpg'),
            mockFile('3.jpg'),
            mockFile('4.jpg'),
          ]),
          true,
        );
      });

      test('returns true for 5 photos', () {
        expect(
          repository.hasMinimumPhotos([
            mockFile('1.jpg'),
            mockFile('2.jpg'),
            mockFile('3.jpg'),
            mockFile('4.jpg'),
            mockFile('5.jpg'),
          ]),
          true,
        );
      });
    });

    group('hasMaximumPhotos', () {
      test('returns false for empty list', () {
        expect(repository.hasMaximumPhotos([]), false);
      });

      test('returns false for 4 photos', () {
        expect(
          repository.hasMaximumPhotos([
            mockFile('1.jpg'),
            mockFile('2.jpg'),
            mockFile('3.jpg'),
            mockFile('4.jpg'),
          ]),
          false,
        );
      });

      test('returns true for 5 photos (maximum)', () {
        expect(
          repository.hasMaximumPhotos([
            mockFile('1.jpg'),
            mockFile('2.jpg'),
            mockFile('3.jpg'),
            mockFile('4.jpg'),
            mockFile('5.jpg'),
          ]),
          true,
        );
      });

      test('returns true for 6 photos (over maximum)', () {
        expect(
          repository.hasMaximumPhotos([
            mockFile('1.jpg'),
            mockFile('2.jpg'),
            mockFile('3.jpg'),
            mockFile('4.jpg'),
            mockFile('5.jpg'),
            mockFile('6.jpg'),
          ]),
          true,
        );
      });
    });
  });
}
