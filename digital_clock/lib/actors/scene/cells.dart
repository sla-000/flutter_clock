import 'dart:math' as math;

import 'package:digital_clock/actors/cell/cell.dart';
import 'package:digital_clock/engine/actor.dart';
import 'package:digital_clock/engine/vector.dart';

void initCells(List<Actor> children) {
  for (double q = 100; q <= 900; q += 100) {
    children.add(
      Cell(
        position: Vector(x: q, y: 100),
        angle: math.Random.secure().nextDouble() * 2 * math.pi,
      ),
    );
  }

  for (double q = 100; q <= 900; q += 100) {
    children.add(
      Cell(
        position: Vector(x: q, y: 1900),
        angle: math.Random.secure().nextDouble() * 2 * math.pi,
      ),
    );
  }

  for (double q = 200; q <= 1800; q += 100) {
    children.add(
      Cell(
        position: Vector(x: 100, y: q),
        angle: math.Random.secure().nextDouble() * 2 * math.pi,
      ),
    );
  }

  for (double q = 200; q <= 1800; q += 100) {
    children.add(
      Cell(
        position: Vector(x: 900, y: q),
        angle: math.Random.secure().nextDouble() * 2 * math.pi,
      ),
    );
  }
}
