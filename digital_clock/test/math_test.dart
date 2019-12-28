import 'dart:math';

import 'package:digital_clock/engine/math.dart';
import 'package:digital_clock/engine/vector.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test getVectorAngle', () {
    expect(getVectorAngle(Vector(x: 0, y: 1)), moreOrLessEquals(pi / 2));

    expect(getVectorAngle(Vector(x: 0, y: -1)), moreOrLessEquals(pi * 3 / 2));

    expect(getVectorAngle(Vector(x: 1, y: 0)), moreOrLessEquals(0));

    expect(getVectorAngle(Vector(x: -1, y: 0)), moreOrLessEquals(pi));
  });

  test('Test getVectorAngle', () {
    expect(getNextAngle(0, pi * 3 / 4), moreOrLessEquals(pi / 4));
    expect(getNextAngle(0, pi * 5 / 4), moreOrLessEquals(pi * 7 / 4));

    expect(getNextAngle(pi / 2, pi * 7 / 4), moreOrLessEquals(pi / 4));
    expect(getNextAngle(pi / 2, pi * 5 / 4), moreOrLessEquals(pi * 3 / 4));

    expect(getNextAngle(pi, pi * 1 / 4), moreOrLessEquals(pi * 3 / 4));
    expect(getNextAngle(pi, pi * 7 / 4), moreOrLessEquals(pi * 5 / 4));

    expect(getNextAngle(pi * 3 / 2, pi * 1 / 4), moreOrLessEquals(pi * 7 / 4));
    expect(getNextAngle(pi * 3 / 2, pi * 3 / 4), moreOrLessEquals(pi * 5 / 4));
  });

  group('', () {
    test('Test getDirection 1', () {
      expect(getDirection(0).contains(Direction.east), true);
      expect(getDirection(pi / 2).contains(Direction.south), true);
      expect(getDirection(pi).contains(Direction.west), true);
      expect(getDirection(pi * 3 / 2).contains(Direction.north), true);

      expect(getDirection(0).length, 1);
      expect(getDirection(pi / 2).length, 1);
      expect(getDirection(pi).length, 1);
      expect(getDirection(pi * 3 / 2).length, 1);
    });

    test('Test getDirection 2', () {
      expect(getDirection(pi * 1 / 4).contains(Direction.south), true);
      expect(getDirection(pi * 1 / 4).contains(Direction.east), true);
      expect(getDirection(pi * 1 / 4).length, 2);

      expect(getDirection(pi * 3 / 4).contains(Direction.south), true);
      expect(getDirection(pi * 3 / 4).contains(Direction.west), true);
      expect(getDirection(pi * 3 / 4).length, 2);

      expect(getDirection(pi * 5 / 4).contains(Direction.north), true);
      expect(getDirection(pi * 5 / 4).contains(Direction.west), true);
      expect(getDirection(pi * 5 / 4).length, 2);

      expect(getDirection(pi * 7 / 4).contains(Direction.north), true);
      expect(getDirection(pi * 7 / 4).contains(Direction.east), true);
      expect(getDirection(pi * 7 / 4).length, 2);
    });
  });
}
