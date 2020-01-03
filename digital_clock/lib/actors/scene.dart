import 'dart:math' as math;

import 'package:digital_clock/engine/vector.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../engine/actor.dart';
import 'cell/cell.dart';
import 'manna.dart';

final Logger _log = Logger('Scene')..level = Level.FINEST;

const double kSizeX = 1000;
const double kSizeY = 2000;

class Scene extends Actor {
  Scene({
    @required String name,
  }) : super(
          name: 'scene-$name',
          position: Vector.zero(),
          size: Vector(x: kSizeX, y: kSizeY),
          image: null,
        ) {
    for (int q = 100; q <= 1900; q += 50) {
      children.add(Manna(
        name: '$q',
        position: Vector(x: 500, y: q.toDouble()),
      ));
    }

//    if (name == '1') {
//      final double scale = math.Random.secure().nextDouble() * 1 + 1;
//
//      children.add(
//        Cell(
//          name: 'top-1',
//          position: Vector(x: 200, y: 100),
//          scale: Vector.both(scale),
//          velocityAngle: math.pi * 1 / 4,
//          velocity: 200,
//          rotation: math.Random.secure().nextDouble() * 2 * math.pi,
//        ),
//      );
//
//      children.add(
//        Cell(
//          name: 'top-2',
//          position: Vector(x: 300, y: 100),
//          scale: Vector.both(scale),
//          velocityAngle: math.pi * 3 / 4,
//          velocity: 250,
//          rotation: math.Random.secure().nextDouble() * 2 * math.pi,
//        ),
//      );
//    }
//
//    return;

    for (double q = 100; q <= 900; q += 100) {
      final double scale = math.Random.secure().nextDouble() * 1 + 1;

      if (q == 100) {
        _log.finest(() => 'Scene: q=$q');
      }

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
}
