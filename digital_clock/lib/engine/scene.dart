import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import 'actor.dart';
import 'cell.dart';
import 'manna.dart';

class Scene extends Actor {
  Scene({
    @required String name,
  }) : super(
          name: 'scene-$name',
          x: 0,
          y: 0,
          width: 500,
          height: 1000,
          image: null,
        ) {
    for (int q = 100; q <= 900; q += 100) {
      children.add(Manna(
        name: '$q',
        x: 250,
        y: q.toDouble(),
      ));
    }

    for (double q = 100; q <= 400; q += 100) {
      final double scale = math.Random.secure().nextDouble() * 2 + 0.2;

      children.add(
        Cell(
          name: 'top-$q',
          x: q,
          y: 100,
          scaleX: scale,
          scaleY: scale,
          rotation: math.Random.secure().nextDouble() * 2 * math.pi,
          velocity: math.Random.secure().nextDouble() * 10 + 1,
        ),
      );
    }

    for (double q = 100; q <= 400; q += 100) {
      final double scale = math.Random.secure().nextDouble() * 1 + 0.2;

      children.add(
        Cell(
          name: 'bottom-$q',
          x: q,
          y: 900,
          scaleX: scale,
          scaleY: scale,
          rotation: math.Random.secure().nextDouble() * 2 * math.pi,
          velocity: math.Random.secure().nextDouble() * 10 + 1,
        ),
      );
    }

    for (double q = 200; q <= 800; q += 100) {
      final double scale = math.Random.secure().nextDouble() * 1 + 0.2;

      children.add(
        Cell(
          name: 'left-$q',
          x: 100,
          y: q,
          scaleX: scale,
          scaleY: scale,
          rotation: math.Random.secure().nextDouble() * 2 * math.pi,
          velocity: math.Random.secure().nextDouble() * 10 + 1,
        ),
      );
    }

    for (double q = 200; q <= 800; q += 100) {
      final double scale = math.Random.secure().nextDouble() * 1 + 0.2;

      children.add(
        Cell(
          name: 'right-$q',
          x: 400,
          y: q,
          scaleX: scale,
          scaleY: scale,
          rotation: math.Random.secure().nextDouble() * 2 * math.pi,
          velocity: math.Random.secure().nextDouble() * 10 + 1,
        ),
      );
    }
  }
}
