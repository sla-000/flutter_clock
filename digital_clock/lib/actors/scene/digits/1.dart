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

  mannaLine(
    children: children,
    startPosition: Vector(x: kSizeX - 200, y: 200),
    endPosition: Vector(x: kSizeX - 200, y: kSizeY - 200),
  );

  mannaCurve(
    children: children,
    startPosition: Vector(x: 220, y: 200),
    startAngle: 1.2 / 2 * math.pi,
    totalDeltaAngle: -1.2 / 2 * math.pi,
    fragmentsNum: 22,
  );
}
