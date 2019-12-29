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
    this.speed = math.pi,
  }) : super(current: current);

  final double speed;

  @override
  void next(double desired, double millis) {
    if (current == null) {
      current = desired;
      return;
    }

    if (current == desired) {
      return;
    }

    double nextCurrent;

    final double delta = getAngleDelta(current, desired);
    if (delta < 0) {
      nextCurrent = _dec(desired, millis);
    } else {
      nextCurrent = _add(desired, millis);
    }
    current = clamp2pi(nextCurrent);
  }

  double _add(double desired, double millis) {
    return current + _step(millis);
  }

  double _dec(double desired, double millis) {
    return current - _step(millis);
  }

  double _step(double millis) {
    return speed * millis / 1000;
  }
}
