import 'dart:math' as math;

import 'package:digital_clock/actors/scene/digits/utils.dart';
import 'package:digital_clock/actors/scene/scene.dart';
import 'package:digital_clock/engine/actor.dart';
import 'package:digital_clock/engine/vector.dart';

void set4(List<Actor> children) {
  mannaLine(
    children: children,
    startPosition: Vector(x: kSizeX - 200, y: 200),
    endPosition: Vector(x: kSizeX - 200, y: kSizeY - 200),
  );

  Vector end = mannaLine(
    children: children,
    startPosition: Vector(x: 200, y: 200),
    endPosition: Vector(x: 200, y: kSizeY / 2),
  );

  mannaCurve(
    children: children,
    startPosition: end,
    startAngle: 1 / 6 * math.pi,
    totalDeltaAngle: -2 / 6 * math.pi,
    fragmentsNum: 13,
  );
}
