import 'dart:math' as math;

import 'package:digital_clock/actors/scene/digits/utils.dart';
import 'package:digital_clock/actors/scene/scene.dart';
import 'package:digital_clock/engine/actor.dart';
import 'package:digital_clock/engine/vector.dart';

void set6(List<Actor> children) {
// bottom

  Vector end = mannaCurve(
    children: children,
    startPosition: Vector(x: 200, y: 1050),
    startAngle: 9 / 6 * math.pi,
    totalDeltaAngle: 6 / 6 * math.pi,
    fragmentsNum: 19,
  );

  end = mannaLine(
    children: children,
    startPosition: end,
    endPosition: Vector(x: end.x, y: kSizeY - 470),
  );

  end = mannaCurve(
    children: children,
    startPosition: end,
    startAngle: 3 / 6 * math.pi,
    totalDeltaAngle: 6 / 6 * math.pi,
    fragmentsNum: 19,
  );

  end = mannaLine(
    children: children,
    startPosition: end,
    endPosition: Vector(x: 200, y: 1050),
  );

  // top

  mannaCurve(
    children: children,
    startPosition: Vector(x: 200, y: kSizeY / 2),
    startAngle: 9 / 6 * math.pi,
    totalDeltaAngle: 1.5 / 6 * math.pi,
    fragmentsNum: 18,
  );
}
