import 'package:digital_clock/engine/vector.dart';
import 'package:digital_clock/utils/assets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'actor.dart';

class Tail extends Actor {
  Tail({
    @required String name,
    @required Vector position,
    Vector scale,
  }) : super(
          name: 'tail-$name',
          position: position,
          size: Vector(x: 6, y: 6),
          scale: scale,
          colorFilter: ColorFilter.mode(Colors.green, BlendMode.modulate),
          image: Assets.instance.tailImages[0],
        );

  int _index = 0;

  @override
  void update(Actor root, double millis) {
    final int framesPassed = (millis / 16).round();
    image = Assets.instance.tailImages[_index];
    _index += framesPassed;
    if (_index >= Assets.instance.tailImages.length) {
      _index = 0;
    }

    super.update(root, millis);
  }
}
