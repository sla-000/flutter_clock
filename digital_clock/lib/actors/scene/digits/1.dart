import 'dart:math' as math;

import 'package:digital_clock/actors/scene/digits/utils.dart';
import 'package:digital_clock/actors/scene/scene.dart';
import 'package:digital_clock/engine/actor.dart';
import 'package:digital_clock/engine/vector.dart';

void set1(List<Actor> children) {
//  mannaLine(
//    children,
//    Vector(x: kSizeX / 2, y: 200),
//    Vector(x: kSizeX / 2, y: kSizeY - 200),
//  );
//
//  mannaLine(
//    children,
//    Vector(x: kSizeX / 2, y: 200),
//    Vector(x: kSizeX / 2 - 200, y: 400),
//  );

  Vector end = mannaCurve(
    children: children,
    startPosition: Vector(x: kSizeX - 200, y: 270),
    startAngle: 5 / 4 * math.pi,
    totalDeltaAngle: -math.pi,
    fragmentsNum: 24,
  );

  end = mannaLine(
    children: children,
    startPosition: end,
    endPosition: Vector(
      x: kSizeX - end.x,
      y: kSizeY - end.y,
    ),
  );

  mannaCurve(
    children: children,
    startPosition: end,
    startAngle: 1 / 4 * math.pi,
    totalDeltaAngle: math.pi,
    fragmentsNum: 24,
  );
}
