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
          width: 50,
          height: 50,
          scaleX: scaleX,
          scaleY: scaleY,
          rotation: rotation,
          velocity: velocity,
          image: Assets.instance.bodyImage,
        ) {
    children.add(Eye(
      name: name,
      x: 10,
      y: 0,
      scaleY: scaleY,
      scaleX: scaleY,
    ));

    children.add(Tail(
      name: name,
      x: -32,
      y: 0,
      scaleY: scaleY,
      scaleX: scaleY,
    ));
  }

  @override
  void update(Actor root, double millis) {
    rotation ??= 0;

    rotation += 0.2 * 2 * 3.1415 * (millis / 1000);

    super.update(root, millis);
  }
}
