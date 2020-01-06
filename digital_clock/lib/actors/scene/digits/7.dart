import 'dart:math' as math;

import 'package:digital_clock/actors/scene/digits/utils.dart';
import 'package:digital_clock/engine/actor.dart';
import 'package:digital_clock/engine/vector.dart';

void set7(List<Actor> children) {
  Vector end = mannaCurve(
    children: children,
    startPosition: Vector(x: 200, y: 200),
    startAngle: 1 / 6 * math.pi,
    totalDeltaAngle: -2 / 6 * math.pi,
    fragmentsNum: 13,
  );

  end = mannaCurve(
    children: children,
    startPosition: end,
    startAngle: 4 / 6 * math.pi,
    totalDeltaAngle: -1.2 / 6 * math.pi,
    fragmentsNum: 33,
  );
}
