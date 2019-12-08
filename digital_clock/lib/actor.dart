import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'assets.dart' as assets;
import 'config.dart';

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
    this.colorFilter,
    this.image,
  })
      : assert(name != null),
        assert(x != null),
        assert(y != null),
        assert(width != null),
        assert(height != null) {
    pivotX ??= width / 2;
    pivotY ??= height / 2;
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
  ColorFilter colorFilter;
  ui.Image image;

  final List<Actor> children = <Actor>[];

  @override
  @mustCallSuper
  void update(Actor root, double millis) {
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
          other is Actor && runtimeType == other.runtimeType &&
              name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return 'Actor{name: $name, x: $x, y: $y, width: $width, height: $height, '
        'rotation: $rotation, children: $children}';
  }
}

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
    image: assets.bodyImage,
  );

  @override
  void update(Actor root, double millis) {
    rotation ??= 0;

    rotation += 2 * 3.1415 * (millis / 1000);

    super.update(root, millis);
  }
}

class Scene extends Actor {
  Scene({
    @required String name,
  }) : super(
    name: 'scene-$name',
    x: 0,
    y: 0,
    width: 500,
    height: 1000,
    image: null,
  ) {
    for (int q = 100; q <= 900; q += 100) {
      children.add(Manna(
        name: '$q',
        x: 250,
        y: q.toDouble(),
      ));
    }

    for (int q = 0; q < 10; ++q) {
      final double scale = Random.secure().nextDouble() * 2 + 0.2;

      children.add(Cell(
        name: '$q',
        x: Random.secure().nextInt(500).toDouble(),
        y: Random.secure().nextInt(1000).toDouble(),
        scaleX: scale,
        scaleY: scale,
        rotation: Random.secure().nextDouble() * 2 * 3.14,
      ));
    }
  }
}

class Manna extends Actor {
  Manna({
    @required String name,
    @required double x,
    @required double y,
  }) : super(
    name: 'manna-$name',
    x: x,
    y: y,
    width: 10,
    height: 10,
    image: assets.mannaImage,
  );
}
