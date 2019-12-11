import 'package:digital_clock/utils/assets.dart';
import 'package:flutter/foundation.dart';

import 'actor.dart';

class Cell extends Actor {
  Cell({
    @required String name,
    @required double x,
    @required double y,
    double scaleX,
    double scaleY,
    double rotation,
  }) : super(
          name: 'cell-$name',
          x: x,
          y: y,
          width: 50,
          height: 50,
          scaleX: scaleX,
          scaleY: scaleY,
          rotation: rotation,
          image: Assets.instance.bodyImage,
        );

  @override
  void update(Actor root, double millis) {
    rotation ??= 0;

    rotation += 2 * 3.1415 * (millis / 1000);

    super.update(root, millis);
  }
}
