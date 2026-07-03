import 'package:prayer_time_plus/src/methods/method_params.dart';
import 'package:test/test.dart';

void main() {
  group('methodParams table', () {
    test('holds 56 rows of 11 columns each', () {
      expect(methodParams, hasLength(56));
      for (final entry in methodParams.entries) {
        expect(entry.value, hasLength(11), reason: entry.key);
      }
    });

    test('spot-checks exact literals', () {
      expect(methodParams['mwl'], [18.0, 1, 0, 0, 17.0, 0, 0, 0, 0, 0, 0]);
      expect(methodParams['makkah'], [18.5, 1, 0, 1, 90.0, 0, 0, 0, 0, 0, 0]);
      expect(methodParams['oman'], [18.0, 1, 5.0, 0, 18.0, 0, 0, 5, 5, 0, 1]);
      expect(methodParams['morocco'], [
        19.09,
        0,
        0,
        0,
        17.0,
        0,
        -2,
        5,
        0,
        3,
        0,
      ]);
      expect(methodParams['turkey'], [18.0, 0, 0, 0, 16.93, 0, -6, 6, 4, 5, 0]);
      expect(methodParams['switzerland'], [
        17.99,
        0,
        0,
        1,
        100.0,
        1,
        4,
        0,
        0,
        -4,
        0,
      ]);
      expect(methodParams['uoif'], [12.0, 1, 0, 0, 12.0, -5, 0, 5, 0, 4, 5]);
      expect(methodParams['czech'], [12.04, 0, 0, 0, 12.04, 0, 0, 5, 0, -2, 0]);
      expect(methodParams['emirates'], [
        18.5,
        1,
        2.0,
        0,
        18.5,
        1,
        -4,
        2,
        0,
        0,
        -3,
      ]);
      expect(methodParams['omanMuscat'], [
        17.74,
        0,
        0,
        0,
        18.229,
        0,
        1,
        6,
        6,
        6,
        0,
      ]);
    });

    test('paramsForKey falls back to mwl for unknown keys', () {
      expect(paramsForKey('dubai'), methodParams['mwl']);
      expect(paramsForKey('no-such-method'), methodParams['mwl']);
      expect(paramsForKey('oman'), methodParams['oman']);
    });
  });
}
