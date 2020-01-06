import 'dart:math' as math;

import 'package:digital_clock/actors/scene/digits/utils.dart';
import 'package:digital_clock/actors/scene/scene.dart';
import 'package:digital_clock/engine/actor.dart';
import 'package:digital_clock/engine/vector.dart';

void set2(List<Actor> children) {
  Vector end = mannaCurve(
    children: children,
    startPosition: Vector(x: 200, y: 340),
    startAngle: 10 / 6 * math.pi,
    totalDeltaAngle: math.pi,
    fragmentsNum: 21,
  );

  end = mannaLine(
    children: children,
    startPosition: end,
    endPosition: Vector(x: 200, y: kSizeY - 200),
  );

  mannaCurve(
    children: children,
    startPosition: end,
    startAngle: 11.5 / 6 * math.pi,
    totalDeltaAngle: 1 / 6 * math.pi,
    fragmentsNum: 13,
  );
}
