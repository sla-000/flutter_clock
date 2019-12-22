import 'dart:math' as math;

import 'package:digital_clock/engine/vector.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import 'actor.dart';
import 'cell.dart';
import 'manna.dart';

final Logger _log = Logger('Scene')..level = Level.FINEST;

class Scene extends Actor {
  Scene({
    @required String name,
  }) : super(
          name: 'scene-$name',
    position: Vector.zero(),
    size: Vector(x: 500, y: 1000),
          image: null,
        ) {
    for (int q = 100; q <= 900; q += 100) {
      children.add(Manna(
        name: '$q',
        position: Vector(x: 250, y: q.toDouble()),
      ));
    }

    for (double q = 100; q <= 400; q += 100) {
      final double scale = math.Random.secure().nextDouble() * 1 + 1;

      if (q == 100) {
        _log.finest(() => 'Scene: q=$q');
      }

      children.add(
        Cell(
          name: 'top-$q',
          position: Vector(x: q, y: 100),
          scale: Vector.both(scale),
          rotation: math.Random.secure().nextDouble() * 2 * math.pi,
        ),
      );
    }

    for (double q = 100; q <= 400; q += 100) {
      final double scale = math.Random.secure().nextDouble() * 1 + 1;

      children.add(
        Cell(
          name: 'bottom-$q',
          position: Vector(x: q, y: 900),
          scale: Vector.both(scale),
          rotation: math.Random.secure().nextDouble() * 2 * math.pi,
        ),
      );
    }

    for (double q = 200; q <= 800; q += 100) {
      final double scale = math.Random.secure().nextDouble() * 1 + 1;

      children.add(
        Cell(
          name: 'left-$q',
          position: Vector(x: 100, y: q),
          scale: Vector.both(scale),
          rotation: math.Random.secure().nextDouble() * 2 * math.pi,
        ),
      );
    }

    for (double q = 200; q <= 800; q += 100) {
      final double scale = math.Random.secure().nextDouble() * 1 + 1;

      children.add(
        Cell(
          name: 'right-$q',
          position: Vector(x: 400, y: q),
          scale: Vector.both(scale),
          rotation: math.Random.secure().nextDouble() * 2 * math.pi,
        ),
      );
    }
  }
}
