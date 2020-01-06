import 'dart:math' as math;

import 'package:digital_clock/actors/scene/digits/utils.dart';
import 'package:digital_clock/actors/scene/scene.dart';
import 'package:digital_clock/engine/actor.dart';
import 'package:digital_clock/engine/vector.dart';

void set3(List<Actor> children) {
  Vector end = mannaCurve(
    children: children,
    startPosition: Vector(x: 220, y: 300),
    startAngle: 10 / 6 * math.pi,
    totalDeltaAngle: 5 / 6 * math.pi,
    fragmentsNum: 16,
  );

  end = mannaCurve(
    children: children,
    startPosition: end,
    startAngle: 3 / 6 * math.pi,
    totalDeltaAngle: 3 / 6 * math.pi,
    fragmentsNum: 10,
  );

  end = mannaCurve(
    children: children,
    startPosition: end,
    startAngle: 12 / 6 * math.pi,
    totalDeltaAngle: 3 / 6 * math.pi,
    fragmentsNum: 12,
  );

  end = mannaLine(
    children: children,
    startPosition: end,
    endPosition: Vector.copy(end)..y = kSizeY - 500,
  );

  end = mannaCurve(
    children: children,
    startPosition: end,
    startAngle: 3 / 6 * math.pi,
    totalDeltaAngle: 5 / 6 * math.pi,
    fragmentsNum: 17,
  );
}
