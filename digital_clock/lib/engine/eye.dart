import 'package:digital_clock/utils/assets.dart';
import 'package:flutter/foundation.dart';

import 'actor.dart';

class Eye extends Actor {
  Eye({
    @required String name,
    @required double x,
    @required double y,
    double scaleX,
    double scaleY,
    double rotation,
  }) : super(
          name: 'eye-$name',
          x: x,
          y: y,
          width: 10,
          height: 10,
          scaleX: scaleX,
          scaleY: scaleY,
          rotation: rotation,
          image: Assets.instance.eyeImage,
        );

  @override
  void update(Actor root, double millis) {
//    rotation ??= 0;
//
//    rotation += 0.2 * 2 * 3.1415 * (millis / 1000);

    super.update(root, millis);
  }
}
