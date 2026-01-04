import 'package:flutter_test/flutter_test.dart';
import 'package:photo_sequence/src/features/home/domain/transition_type.dart';

void main() {
  group('TransitionType', () {
    group('ffmpegValue', () {
      test('dissolve maps to fade', () {
        expect(TransitionType.dissolve.ffmpegValue, 'fade');
      });

      test('slideLeft maps to slideleft', () {
        expect(TransitionType.slideLeft.ffmpegValue, 'slideleft');
      });

      test('slideRight maps to slideright', () {
        expect(TransitionType.slideRight.ffmpegValue, 'slideright');
      });

      test('slideUp maps to slideup', () {
        expect(TransitionType.slideUp.ffmpegValue, 'slideup');
      });

      test('slideDown maps to slidedown', () {
        expect(TransitionType.slideDown.ffmpegValue, 'slidedown');
      });
    });

    group('displayName', () {
      test('dissolve displays as Dissolve', () {
        expect(TransitionType.dissolve.displayName, 'Dissolve');
      });

      test('slideLeft displays as Slide Left', () {
        expect(TransitionType.slideLeft.displayName, 'Slide Left');
      });

      test('slideRight displays as Slide Right', () {
        expect(TransitionType.slideRight.displayName, 'Slide Right');
      });

      test('slideUp displays as Slide Up', () {
        expect(TransitionType.slideUp.displayName, 'Slide Up');
      });

      test('slideDown displays as Slide Down', () {
        expect(TransitionType.slideDown.displayName, 'Slide Down');
      });
    });

    group('enum values', () {
      test('contains all 5 transition types', () {
        expect(TransitionType.values.length, 5);
      });

      test('values are in expected order', () {
        expect(TransitionType.values[0], TransitionType.dissolve);
        expect(TransitionType.values[1], TransitionType.slideLeft);
        expect(TransitionType.values[2], TransitionType.slideRight);
        expect(TransitionType.values[3], TransitionType.slideUp);
        expect(TransitionType.values[4], TransitionType.slideDown);
      });
    });
  });
}
