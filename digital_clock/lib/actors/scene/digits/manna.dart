import 'package:digital_clock/engine/actor.dart';
import 'package:digital_clock/engine/vector.dart';
import 'package:digital_clock/utils/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Manna extends Actor {
  Manna({
    @required Vector position,
  }) : super(
          position: position,
          size: Vector(x: 10, y: 10),
          image: Assets.instance.mannaImage,
          colorFilter: ColorFilter.mode(
            kReleaseMode ? Colors.transparent : Colors.deepOrange,
            BlendMode.modulate,
          ),
        );
}
