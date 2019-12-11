import 'dart:math';

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

    for (int q = 0; q < 10; ++q) {
      final double scale = Random.secure().nextDouble() * 2 + 0.2;

      children.add(Cell(
        name: '$q',
        x: Random.secure().nextInt(500).toDouble(),
        y: Random.secure().nextInt(1000).toDouble(),
        scaleX: scale,
        scaleY: scale,
        rotation: Random.secure().nextDouble() * 2 * 3.14,
      ));
    }
  }
}
