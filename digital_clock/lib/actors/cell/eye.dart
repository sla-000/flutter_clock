import 'dart:math' as math;

import 'package:digital_clock/engine/actor.dart';
import 'package:digital_clock/engine/vector.dart';
import 'package:digital_clock/utils/assets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Eye extends Actor {
  Eye({
    @required Vector position,
    Vector scale,
  }) : super(
          position: position,
          size: Vector(x: 10, y: 10),
          scale: scale,
          image: Assets.instance.eyeImage,
        );

  void setTired(double tire) {
    final int whiteAlpha = ((1 - tire) * 0xFF).floor();
    final int redAlpha = (tire * 0x80).floor();
    colorFilter = ColorFilter.mode(
        Color.alphaBlend(
          Colors.white.withAlpha(whiteAlpha),
          Colors.red.withAlpha(redAlpha),
        ),
        BlendMode.modulate);
  }

  double _nextRollTime = 0;
  double _accumulatedRollTime = 0;

  @override
  void update(Actor root, double millis) {
    if (millis > 100) {
      millis = 100;
    }

    _eyeRoll(millis);

    super.update(root, millis);
  }

  void _eyeRoll(double millis) {
    _accumulatedRollTime += millis;

    if (_accumulatedRollTime >= _nextRollTime) {
      _nextRollTime = math.Random.secure().nextDouble() * 1200 + 300;
      velocityAngle = math.Random.secure().nextDouble() * 3 - 1.5;
      _accumulatedRollTime = 0;
    }
  }
}
