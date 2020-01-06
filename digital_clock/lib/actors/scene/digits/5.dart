import 'dart:math' as math;

import 'package:digital_clock/actors/scene/digits/utils.dart';
import 'package:digital_clock/actors/scene/scene.dart';
import 'package:digital_clock/engine/actor.dart';
import 'package:digital_clock/engine/vector.dart';

void set5(List<Actor> children) {
  Vector end = mannaCurve(
    children: children,
    startPosition: Vector(x: kSizeX - 200, y: 200),
    startAngle: 5 / 6 * math.pi,
    totalDeltaAngle: 2 / 6 * math.pi,
    fragmentsNum: 13,
  );

  end = mannaLine(
    children: children,
    startPosition: end,
    endPosition: Vector(x: 200, y: kSizeY / 2 - 50),
  );

  end = mannaCurve(
    children: children,
    startPosition: end,
    startAngle: 11 / 6 * math.pi,
    totalDeltaAngle: 4 / 6 * math.pi,
    fragmentsNum: 19,
  );

  end = mannaCurve(
    children: children,
    startPosition: end,
    startAngle: 3 / 6 * math.pi,
    totalDeltaAngle: 4 / 6 * math.pi,
    fragmentsNum: 19,
  );
}
