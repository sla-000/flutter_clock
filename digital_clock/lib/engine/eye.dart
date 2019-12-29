import 'dart:math' as math;

import 'package:digital_clock/engine/vector.dart';
import 'package:digital_clock/utils/assets.dart';
import 'package:flutter/foundation.dart';

import 'actor.dart';

const double _kEyeRollSpeed = 1.5 * 2 * math.pi;

class Eye extends Actor {
  Eye({
    @required String name,
    @required Vector position,
    Vector scale,
  }) : super(
          name: 'eye-$name',
          position: position,
          size: Vector(x: 10, y: 10),
          scale: scale,
          image: Assets.instance.eyeImage,
        );

  @override
  void update(Actor root, double millis) {
    if (millis > 100) {
      millis = 100;
    }

    _eyeRoll(millis);

    movement.rotation.next(rotation, millis);

    super.update(root, millis);
  }

  void _eyeRoll(double millis) {
    _accumulatedRollTime += millis;

    if (_accumulatedRollTime >= _nextRollTime) {
      _nextRollTime = math.Random.secure().nextDouble() * 1200 + 300;
      rotation = math.Random.secure().nextDouble() * 3 - 1.5;
      _accumulatedRollTime = 0;
    }
  }

  double _nextRollTime = 0;
  double _accumulatedRollTime = 0;
}
