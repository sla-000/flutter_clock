import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../config.dart';

abstract class Update {
  void update(Actor root, double millis);
}

abstract class Draw {
  void draw(Canvas canvas);
}

abstract class Actor implements Update, Draw {
  Actor({
    @required this.name,
    @required this.x,
    @required this.y,
    @required this.width,
    @required this.height,
    this.pivotX,
    this.pivotY,
    this.scaleX,
    this.scaleY,
    this.rotation,
    this.velocity,
    this.colorFilter,
    this.image,
  })  : assert(name != null),
        assert(x != null),
        assert(y != null),
        assert(width != null),
        assert(height != null) {
    pivotX ??= width / 2;
    pivotY ??= height / 2;
    rotation ??= 0;
    velocity ??= 0;
  }

  String name;
  double x;
  double y;
  double width;
  double height;
  double pivotX;
  double pivotY;
  double scaleX;
  double scaleY;
  double rotation;
  double velocity;
  ColorFilter colorFilter;
  ui.Image image;

  final List<Actor> children = <Actor>[];

  @override
  @mustCallSuper
  void update(Actor root, double millis) {
    if (velocity != 0) {
      x += velocity * math.cos(rotation) * millis / 1000;
      y += velocity * math.sin(rotation) * millis / 1000;
    }

    for (final Actor actor in children) {
      actor.update(root, millis);
    }
  }

  @override
  void draw(Canvas canvas) {
    canvas.save();

    canvas.translate(x, y);

    canvas.rotate(rotation ?? 0);

    canvas.scale(scaleX ?? 1, scaleY ?? 1);

    if (image != null) {
      paintImage(
        canvas: canvas,
        rect: Rect.fromCenter(
          center: Offset.zero,
          width: width,
          height: height,
        ),
        colorFilter: colorFilter,
        filterQuality: Config.instance.filterQuality,
        image: image,
      );
    }

    for (final Actor actor in children) {
      actor.draw(canvas);
    }

    canvas.restore();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Actor && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return 'Actor{name: $name, x: $x, y: $y, width: $width, height: $height, '
        'rotation: $rotation, children: $children}';
  }
}
