import 'package:digital_clock/engine/tail.dart';
import 'package:digital_clock/utils/assets.dart';
import 'package:flutter/foundation.dart';

import 'actor.dart';
import 'eye.dart';

class Cell extends Actor {
  Cell({
    @required String name,
    @required double x,
    @required double y,
    double scaleX,
    double scaleY,
    double rotation,
    double velocity,
  }) : super(
          name: 'cell-$name',
          x: x,
          y: y,
          width: 40,
          height: 40,
          scaleX: scaleX,
          scaleY: scaleY,
          rotation: rotation,
          velocity: velocity,
          image: Assets.instance.bodyImage,
        ) {
    tail = Tail(
      name: name,
      x: -22,
      y: 0,
      scaleX: scaleX,
      scaleY: scaleY,
    );
    children.add(tail);

    eye = Eye(
      name: name,
      x: 8,
      y: 0,
      scaleX: 1.2 / scaleX + 0.8,
      scaleY: 1.2 / scaleY + 0.8,
    );

    children.add(eye);
  }

  Actor eye;

  Actor tail;

  @override
  void update(Actor root, double millis) {
    rotation ??= 0;

    rotation += 0.2 * 2 * 3.1415 * (millis / 1000);

    super.update(root, millis);
  }
}
