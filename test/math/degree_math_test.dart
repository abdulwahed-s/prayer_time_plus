import 'package:prayer_time_plus/src/math/degree_math.dart';
import 'package:test/test.dart';

void main() {
  group('degree trig', () {
    test('sinDeg/cosDeg/tanDeg work in degrees', () {
      expect(sinDeg(30), closeTo(0.5, 1e-12));
      expect(cosDeg(60), closeTo(0.5, 1e-12));
      expect(tanDeg(45), closeTo(1.0, 1e-12));
      expect(sinDeg(-90), closeTo(-1.0, 1e-12));
    });

    test('arcsinDeg/arccosDeg return degrees', () {
      expect(arcsinDeg(1.0), closeTo(90.0, 1e-12));
      expect(arccosDeg(-1.0), closeTo(180.0, 1e-12));
    });

    test('arccotDeg uses atan2(1, x), not 1/tan', () {
      expect(arccotDeg(1.0), closeTo(45.0, 1e-12));
      // For negative arguments atan2(1, x) lands in the second quadrant;
      // a naive atan(1/x) would return -45 here.
      expect(arccotDeg(-1.0), closeTo(135.0, 1e-12));
      expect(arccotDeg(0.0), closeTo(90.0, 1e-12));
    });

    test('arctan2Deg matches atan2 argument order (y, x)', () {
      expect(arctan2Deg(1.0, 0.0), closeTo(90.0, 1e-12));
      expect(arctan2Deg(-1.0, 0.0), closeTo(-90.0, 1e-12));
    });
  });

  group('fixAngle', () {
    test('wraps into [0, 360)', () {
      expect(fixAngle(0), 0);
      expect(fixAngle(360), 0);
      expect(fixAngle(720.5), closeTo(0.5, 1e-12));
      expect(fixAngle(-30), closeTo(330.0, 1e-12));
      expect(fixAngle(-360), 0);
    });

    test('propagates NaN', () {
      expect(fixAngle(double.nan).isNaN, isTrue);
    });
  });

  group('fixHour', () {
    test('wraps into [0, 24)', () {
      expect(fixHour(24), 0);
      expect(fixHour(25.25), closeTo(1.25, 1e-12));
      expect(fixHour(-1), closeTo(23.0, 1e-12));
      expect(fixHour(-25), closeTo(23.0, 1e-12));
    });

    test('propagates NaN', () {
      expect(fixHour(double.nan).isNaN, isTrue);
    });
  });

  test('timeDiff is fixHour(to - from)', () {
    expect(timeDiff(19.0, 5.0), closeTo(10.0, 1e-12));
    expect(timeDiff(5.0, 19.0), closeTo(14.0, 1e-12));
  });
}
