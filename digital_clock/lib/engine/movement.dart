import 'dart:math' as math;

import 'package:digital_clock/engine/math.dart';

class Movement {
  CalculateNextRotation rotation = CalculateNextRotation();

  @override
  String toString() {
    return 'Movement{rotation: $rotation}';
  }
}

abstract class CalculateNext<T> {
  CalculateNext({
    this.current,
  });

  T current;

  void next(T desired, double millis);
}

class CalculateNextRotation extends CalculateNext<double> {
  CalculateNextRotation({
    double current,
    this.speed = math.pi * 1.0,
  }) : super(current: current);

  final double speed;

  @override
  void next(double desired, double millis) {
    if (current == null) {
      current = desired;
      return;
    }

    if (current.equalAngle(desired)) {
      return;
    }

    double nextCurrent;

    final double delta = getAngleDelta(current, desired);

    nextCurrent = _calcNext(delta, millis);

    current = clamp2pi(nextCurrent);
  }

  double _calcNext(double delta, double millis) {
    return current + delta * _step(millis);
  }

  double _step(double millis) {
    return speed * millis / 1000;
  }
}

extension on double {
  bool equalAngle(double other) {
    return (other - this).abs() < 0.03;
  }
}
