import 'dart:math' as math;

import 'package:digital_clock/actors/scene/digits/manna.dart';
import 'package:digital_clock/engine/actor.dart';
import 'package:digital_clock/engine/vector.dart';
import 'package:logging/logging.dart';

final Logger _log = Logger('Utils')..level = Level.FINEST;

void mannaLine(
  List<Actor> children,
  Vector vector0,
  Vector vector1,
) {
  final Vector lineDelta = vector1 - vector0;

  final Vector line1 = lineDelta.reduceToLength(50);
  final double partsNum = lineDelta.length / line1.length;

  for (double q = 0; q <= partsNum; q++) {
    final Vector currentPoint = vector0 + line1 * q;

    children.add(Manna(
      position: currentPoint,
    ));
  }
}

void curve(
  List<Actor> children,
  Vector v0,
  Vector v1,
  int pointsNum,
  double sphereKoeff, // 0.5 is half-sphere
) {
  _log.finest(() => 'curve: ------------------------');

  final double totalAngle = pointsNum * math.pi;
  _log.finest(() => 'curve: totalAngle=$totalAngle');

  final double vectorAngle = totalAngle / (pointsNum + 2 * sphereKoeff);
  _log.finest(() => 'curve: vectorAngle=$vectorAngle');

  final double halfAngle = vectorAngle * sphereKoeff;
  _log.finest(() => 'curve: halfAngle=$halfAngle');

  final Vector directVector = v1 - v0;
  _log.finest(() => 'curve: directVector=$directVector');

  final Vector firstVector = directVector
      .reduceToLength(
          directVector.length * math.pow(sphereKoeff / math.sqrt1_2, pointsNum))
      .rotate(halfAngle);
  _log.finest(() => 'curve: firstVector=$firstVector');

  Vector currentPositionVector = Vector.copy(v0);
  Vector nextVector = firstVector;

  currentPositionVector += nextVector;
  _log.finest(() => 'curve: currentPositionVector=$currentPositionVector');
  children.add(Manna(
    position: currentPositionVector,
  ));

  for (int q = 1; q < pointsNum; ++q) {
    nextVector = nextVector.rotate(-(math.pi - vectorAngle));

    currentPositionVector += nextVector;
    _log.finest(() => 'curve: currentPositionVector=$currentPositionVector');
    children.add(Manna(
      position: currentPositionVector,
    ));
  }
}
