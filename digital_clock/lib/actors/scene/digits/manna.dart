import 'package:digital_clock/config.dart';
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
        );
}

void drawManna(Canvas canvas, Actor actor) {
  return paintImage(
    canvas: canvas,
    rect: Rect.fromCenter(
      center: Offset.zero,
      width: actor.size.x,
      height: actor.size.y,
    ),
    colorFilter: ColorFilter.mode(
      kReleaseMode ? Colors.transparent : Colors.deepOrange,
      BlendMode.modulate,
    ),
    filterQuality: Config.instance.filterQuality,
    image: Assets.instance.mannaImage,
  );
}
