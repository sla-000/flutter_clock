import 'dart:math' as math;

import 'package:digital_clock/engine/actor.dart';
import 'package:digital_clock/engine/vector.dart';
import 'package:digital_clock/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Body extends Actor {
  Body()
      : super(
          position: Vector.zero(),
          size: Vector(x: 40, y: 40),
          image: Assets.instance.bodyImage,
        );

  final double rotationSpeed =
      math.Random.secure().nextDouble() * 0.4 * math.pi;

  void setTired(double tire) {
    final int blackAlpha = (tire * 0xA0).floor();
    colorFilter =
        ColorFilter.mode(Colors.black.withAlpha(blackAlpha), BlendMode.srcOver);
  }

  @override
  void update(Actor root, double millis) {
    velocityAngle += rotationSpeed * millis / 1000;

    super.update(root, millis);
  }
}
