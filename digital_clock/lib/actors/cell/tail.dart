import 'package:digital_clock/config.dart';
import 'package:digital_clock/engine/actor.dart';
import 'package:digital_clock/engine/vector.dart';
import 'package:digital_clock/utils/assets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

const int kTailImagesNum = 10;

class Tail extends Actor {
  Tail({
    @required Vector position,
    Vector scale,
  }) : super(
          position: position,
          size: Vector(x: 6, y: 6),
          scale: scale,
        );

  int _index = 0;

  @override
  void update(Actor root, double millis) {
    final int framesPassed = (millis / 16).round();

    _index += framesPassed;
    if (_index >= kTailImagesNum) {
      _index = 0;
    }

    super.update(root, millis);
  }
}

void drawTail(Canvas canvas, Actor actor) {
  final Tail _actor = actor;

  return paintImage(
    canvas: canvas,
    rect: Rect.fromCenter(
      center: Offset.zero,
      width: actor.size.x,
      height: actor.size.y,
    ),
    colorFilter: ColorFilter.mode(Colors.green, BlendMode.modulate),
    filterQuality: Config.instance.filterQuality,
    image: Assets.instance.tailImages[_actor._index],
  );
}
