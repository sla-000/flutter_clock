import 'dart:math' as math;

import 'package:digital_clock/engine/vector.dart';

double clamp2pi(double value) {
  while (value < 0) {
    value += 2 * math.pi;
  }

  while (value > 2 * math.pi) {
    value -= 2 * math.pi;
  }

  return value;
}

enum Direction {
  west,
  east,
  north,
  south,
}

List<Direction> getDirection(double velocityAngle) {
  final List<Direction> rez = <Direction>[];

  if (velocityAngle > math.pi * 1 / 2 && velocityAngle < math.pi * 3 / 2) {
    rez.add(Direction.west);
  } else if ((velocityAngle >= 0 && //
          velocityAngle < math.pi * 1 / 2) || //
      (velocityAngle > math.pi * 3 / 2 && //
          velocityAngle < math.pi * 4 / 2)) {
    rez.add(Direction.east);
  }

  if (velocityAngle > math.pi * 0 / 2 && velocityAngle < math.pi * 2 / 2) {
    rez.add(Direction.south);
  } else if (velocityAngle > math.pi * 2 / 2 &&
      velocityAngle < math.pi * 4 / 2) {
    rez.add(Direction.north);
  }

  return rez;
}

const double kMinGoodByeAngle = math.pi / 2;

double getNextAngle(double obstacleNormalAngle, double velocityAngle) {
  double rez = 2 * obstacleNormalAngle - velocityAngle - math.pi;
  final double delta = rez - velocityAngle;

  if (delta.abs() < kMinGoodByeAngle) {
    if (rez < velocityAngle) {
      rez = velocityAngle - kMinGoodByeAngle;
    } else if (rez >= velocityAngle) {
      rez = velocityAngle + kMinGoodByeAngle;
    }
  }

  return clamp2pi(rez);
}

double getVectorAngle(Vector v) {
  return clamp2pi(math.atan2(v.y, v.x));
}
