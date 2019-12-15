import 'dart:math' as math;

import 'package:digital_clock/utils/assets.dart';
import 'package:flutter/foundation.dart';

import 'actor.dart';

const double _kEyeRollSpeed = 1.5 * 2 * math.pi;

class Eye extends Actor {
  Eye({
    @required String name,
    @required double x,
    @required double y,
    double scaleX,
    double scaleY,
  }) : super(
          name: 'eye-$name',
          x: x,
          y: y,
          width: 10,
          height: 10,
          scaleX: scaleX,
          scaleY: scaleY,
          image: Assets.instance.eyeImage,
        );

  @override
  void update(Actor root, double millis) {
    _eyeRoll(millis);

    if (!rotation.equals(_nextRollRotation, delta: 0.05)) {
      if (rotation < _nextRollRotation) {
        rotation += _kEyeRollSpeed * millis / 1000;
      } else if (rotation > _nextRollRotation) {
        rotation -= _kEyeRollSpeed * millis / 1000;
      }
    }

    super.update(root, millis);
  }

  void _eyeRoll(double millis) {
    _accumulatedRollTime += millis;

    if (_accumulatedRollTime >= _nextRollTime) {
      _nextRollTime = math.Random.secure().nextDouble() * 1200 + 300;
      _nextRollRotation = math.Random.secure().nextDouble() * 3 - 1.5;
      _accumulatedRollTime = 0;
    }
  }

  double _nextRollTime = 0;
  double _accumulatedRollTime = 0;
  double _nextRollRotation = 0;
}

extension Equals on double {
  bool equals(
    double value, {
    double delta = 0.0,
  }) {
    return (this >= (value - delta)) && (this <= (value + delta));
  }
}
