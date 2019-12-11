import 'package:digital_clock/utils/assets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'actor.dart';

class Tail extends Actor {
  Tail({
    @required String name,
    @required double x,
    @required double y,
    double scaleX,
    double scaleY,
  }) : super(
          name: 'tail-$name',
          x: x,
          y: y,
          width: 8,
          height: 8,
          scaleX: scaleX,
          scaleY: scaleY,
          colorFilter: ColorFilter.mode(Colors.green, BlendMode.modulate),
          image: Assets.instance.tailImages[0],
        );

  bool _up = true;
  int _index = 0;

  @override
  void update(Actor root, double millis) {
    image = Assets.instance.tailImages[_index];

    if (_up) {
      if (_index >= Assets.instance.tailImages.length - 1) {
        --_index;
        _up = false;
      } else {
        ++_index;
      }
    } else {
      if (_index <= 0) {
        ++_index;
        _up = true;
      } else {
        --_index;
      }
    }

    super.update(root, millis);
  }
}
