import 'package:flutter_test/flutter_test.dart';
import 'package:photo_sequence/src/features/home/domain/export_settings.dart';

void main() {
  group('ExportSettings', () {
    group('constructor', () {
      test('creates with default values', () {
        const settings = ExportSettings();
        expect(settings.width, 1280);
        expect(settings.height, 720);
        expect(settings.frameRate, 30);
        expect(settings.bitrate, 5000);
      });

      test('creates with custom values', () {
        const settings = ExportSettings(
          width: 1920,
          height: 1080,
          frameRate: 60,
          bitrate: 10000,
        );
        expect(settings.width, 1920);
        expect(settings.height, 1080);
        expect(settings.frameRate, 60);
        expect(settings.bitrate, 10000);
      });
    });

    group('presets', () {
      test('hd720 preset has correct values', () {
        const settings = ExportSettings.hd720;
        expect(settings.width, 1280);
        expect(settings.height, 720);
        expect(settings.frameRate, 30);
        expect(settings.bitrate, 5000);
      });

      test('hd1080 preset has correct values', () {
        const settings = ExportSettings.hd1080;
        expect(settings.width, 1920);
        expect(settings.height, 1080);
        expect(settings.frameRate, 30);
        expect(settings.bitrate, 8000);
      });
    });

    group('resolution', () {
      test('returns formatted resolution string for 720p', () {
        const settings = ExportSettings.hd720;
        expect(settings.resolution, '1280x720');
      });

      test('returns formatted resolution string for 1080p', () {
        const settings = ExportSettings.hd1080;
        expect(settings.resolution, '1920x1080');
      });

      test('returns formatted resolution string for custom values', () {
        const settings = ExportSettings(width: 3840, height: 2160);
        expect(settings.resolution, '3840x2160');
      });
    });

    group('equality', () {
      test('two settings with same values are equal', () {
        const settings1 = ExportSettings(
          width: 1280,
          height: 720,
          frameRate: 30,
          bitrate: 5000,
        );
        const settings2 = ExportSettings(
          width: 1280,
          height: 720,
          frameRate: 30,
          bitrate: 5000,
        );
        expect(settings1, equals(settings2));
      });

      test('two settings with different width are not equal', () {
        const settings1 = ExportSettings(width: 1280);
        const settings2 = ExportSettings(width: 1920);
        expect(settings1, isNot(equals(settings2)));
      });

      test('two settings with different height are not equal', () {
        const settings1 = ExportSettings(height: 720);
        const settings2 = ExportSettings(height: 1080);
        expect(settings1, isNot(equals(settings2)));
      });

      test('two settings with different frameRate are not equal', () {
        const settings1 = ExportSettings(frameRate: 30);
        const settings2 = ExportSettings(frameRate: 60);
        expect(settings1, isNot(equals(settings2)));
      });

      test('two settings with different bitrate are not equal', () {
        const settings1 = ExportSettings(bitrate: 5000);
        const settings2 = ExportSettings(bitrate: 8000);
        expect(settings1, isNot(equals(settings2)));
      });

      test('preset equals equivalent manual construction', () {
        const preset = ExportSettings.hd720;
        const manual = ExportSettings(
          width: 1280,
          height: 720,
          frameRate: 30,
          bitrate: 5000,
        );
        expect(preset, equals(manual));
      });
    });

    group('props', () {
      test('props contains all properties', () {
        const settings = ExportSettings(
          width: 1280,
          height: 720,
          frameRate: 30,
          bitrate: 5000,
        );
        expect(settings.props, [1280, 720, 30, 5000]);
      });
    });
  });
}
