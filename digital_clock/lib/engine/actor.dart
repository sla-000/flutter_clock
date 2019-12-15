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

const double _kRotationSpeed = 0.5 * 2 * math.pi; // rad in second

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
    this.rotation = 0,
    this.velocityX,
    this.velocityY,
    this.colorFilter,
    this.image,
  })  : assert(name != null),
        assert(x != null),
        assert(y != null),
        assert(rotation != null),
        assert(width != null),
        assert(height != null) {
    pivotX ??= width / 2;
    pivotY ??= height / 2;
    velocityX ??= 0;
    velocityY ??= 0;
    _currentRotation = rotation;
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
  double velocityX;
  double velocityY;
  ColorFilter colorFilter;
  ui.Image image;

  double _currentRotation;
  double maxRotationSpeed = _kRotationSpeed;

  final List<Actor> children = <Actor>[];

  @override
  @mustCallSuper
  void update(Actor root, double millis) {
    if (velocityX != 0) {
      x += velocityX * millis / 1000;
    }

    if (velocityX != 0) {
      y += velocityY * millis / 1000;
    }

    if (!rotation.equals(_currentRotation, delta: 0.1)) {
      if (_currentRotation < rotation) {
        _currentRotation += maxRotationSpeed * millis / 1000;
      } else if (_currentRotation > rotation) {
        _currentRotation -= maxRotationSpeed * millis / 1000;
      }
    }

    final List<Actor> tempActors = List<Actor>.of(children, growable: false);

    for (final Actor actor in tempActors) {
      actor.update(root, millis);
    }
  }

  @override
  void draw(Canvas canvas) {
    canvas.save();

    canvas.translate(x, y);

    canvas.rotate(_currentRotation ?? 0);

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

    final List<Actor> tempActors = List<Actor>.of(children, growable: false);

    for (final Actor actor in tempActors) {
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
    return 'Actor{name: $name, '
        'x: $x, y: $y, '
        'velocityX: $velocityX, velocityY: $velocityY, '
        'width: $width, height: $height, '
        'rotation: $_currentRotation, children: $children}';
  }
}

extension Equals on double {
  bool equals(
    double value, {
    double delta = 0.0,
  }) {
    return (this >= (value - delta)) && (this <= (value + delta));
  }
}
