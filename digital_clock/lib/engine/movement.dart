import 'dart:math' as math;

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

    if (desired > current) {
      final double delta = desired - current;
      if (delta > math.pi) {
        nextCurrent = _dec(desired, millis);
      } else {
        nextCurrent = _add(desired, millis);
      }
    } else {
      final double delta = current - desired;
      if (delta < math.pi) {
        nextCurrent = _dec(desired, millis);
      } else {
        nextCurrent = _add(desired, millis);
      }
    }

    current = _clamp2pi(nextCurrent);
  }

  double _add(double desired, double millis) {
    double nextCurrent = current + _step(millis);

    if (nextCurrent > desired) {
      nextCurrent = desired;
    }

    return nextCurrent;
  }

  double _dec(double desired, double millis) {
    double nextCurrent = current - _step(millis);

    if (nextCurrent < desired) {
      nextCurrent = desired;
    }

    return nextCurrent;
  }

  double _step(double millis) {
    return speed * millis / 1000;
  }

  double _clamp2pi(double value) {
    while (value < 0) {
      value += 2 * math.pi;
    }

    while (value > 2 * math.pi) {
      value -= 2 * math.pi;
    }

    return value;
  }
}
