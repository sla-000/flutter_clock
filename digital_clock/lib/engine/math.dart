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

const double kMinMirroredAngle = math.pi / 4;

double getNextAngle(double obstacleNormalAngle, double velocityAngle) {
  double mirrored = 2 * obstacleNormalAngle;
  mirrored = clamp2pi(mirrored);
  mirrored = getAngleDelta(mirrored, velocityAngle);
  mirrored = clamp2pi(mirrored);
  mirrored = getAngleDelta(mirrored, math.pi);
  mirrored = clamp2pi(mirrored);

  mirrored = _preventStuck(velocityAngle, mirrored);

  return clamp2pi(mirrored);
}

double _preventStuck(double initialAngle, double mirroredAngle) {
  final double delta = getAngleDelta(initialAngle, mirroredAngle);

  if (delta.abs() < math.pi * 1 / 4) {
    if (delta < 0) {
      mirroredAngle = getAngleDelta(initialAngle, kMinMirroredAngle);
    } else {
      mirroredAngle = getAngleDelta(initialAngle, -kMinMirroredAngle);
    }
  }

  return mirroredAngle;
}

double getVectorAngle(Vector v) {
  return clamp2pi(math.atan2(v.y, v.x));
}

double getAngleDelta(double angle0, double angle1) {
  double delta = angle1 - angle0;

  final double deltaAbs = delta.abs();

  if (deltaAbs > math.pi) {
    delta = 2 * math.pi - deltaAbs;

    if (angle1 > angle0) {
      delta = -delta;
    }
  }

  return delta;
}

Vector getVectorsSum(Vector vector0, Vector vector1) {
  return Vector(
    x: vector0.x + vector1.x,
    y: vector0.y + vector1.y,
  );
}

extension on double {
  bool equalAngle(double other) {
    return getAngleDelta(other, this).abs() < 0.03;
  }
}

double nextAngle(
  double current,
  double desired,
  double millis, [
  double speed = math.pi,
]) {
  if (current == null) {
    current = desired;
    return desired;
  }

  if (current.equalAngle(desired)) {
    return desired;
  }

  double nextCurrent;

  final double delta = getAngleDelta(current, desired);

  final double frameStep = delta * speed * millis / 1000;

  nextCurrent = current + frameStep;

  return clamp2pi(nextCurrent);
}
