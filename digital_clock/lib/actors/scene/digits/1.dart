import 'dart:math' as math;

import 'package:digital_clock/actors/scene/digits/utils.dart';
import 'package:digital_clock/actors/scene/scene.dart';
import 'package:digital_clock/engine/actor.dart';
import 'package:digital_clock/engine/vector.dart';

void set1(List<Actor> children) {
  Vector end = mannaCurve(
    children: children,
    startPosition: Vector(x: 300, y: 250),
    startAngle: 9 / 6 * math.pi,
    totalDeltaAngle: math.pi,
    fragmentsNum: 7,
  );

  end = mannaLine(
    children: children,
    startPosition: end,
    endPosition: Vector(
      x: 500,
      y: kSizeY - 200,
    ),
  );
}
