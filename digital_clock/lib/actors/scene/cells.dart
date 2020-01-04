import 'dart:math' as math;

import 'package:digital_clock/actors/cell/cell.dart';
import 'package:digital_clock/engine/actor.dart';
import 'package:digital_clock/engine/vector.dart';

void initCells(List<Actor> children) {
  for (double q = 100; q <= 900; q += 100) {
    final double scale = math.Random.secure().nextDouble() * 1 + 1;

    children.add(
      Cell(
        name: 'top-$q',
        position: Vector(x: q, y: 100),
        scale: Vector.both(scale),
        angle: math.Random.secure().nextDouble() * 2 * math.pi,
      ),
    );
  }

  for (double q = 100; q <= 900; q += 100) {
    final double scale = math.Random.secure().nextDouble() * 1 + 1;

    children.add(
      Cell(
        name: 'bottom-$q',
        position: Vector(x: q, y: 1900),
        scale: Vector.both(scale),
        angle: math.Random.secure().nextDouble() * 2 * math.pi,
      ),
    );
  }

  for (double q = 200; q <= 1800; q += 100) {
    final double scale = math.Random.secure().nextDouble() * 1 + 1;

    children.add(
      Cell(
        name: 'left-$q',
        position: Vector(x: 100, y: q),
        scale: Vector.both(scale),
        angle: math.Random.secure().nextDouble() * 2 * math.pi,
      ),
    );
  }

  for (double q = 200; q <= 1800; q += 100) {
    final double scale = math.Random.secure().nextDouble() * 1 + 1;

    children.add(
      Cell(
        name: 'right-$q',
        position: Vector(x: 900, y: q),
        scale: Vector.both(scale),
        angle: math.Random.secure().nextDouble() * 2 * math.pi,
      ),
    );
  }
}
