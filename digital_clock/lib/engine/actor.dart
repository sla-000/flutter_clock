import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:digital_clock/engine/vector.dart';
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
    @required this.position,
    @required this.size,
    this.scale,
    this.pivot,
    this.rotation,
    this.velocity,
    this.colorFilter,
    this.image,
  }) {
    pivot ??= Vector(x: size.x / 2, y: size.y / 2);
    scale ??= Vector.ordinal();
    velocity ??= Vector.zero();
    rotation ??= 0;
    _currentRotation = rotation;
  }

  final String name;
  Vector position;
  Vector size;
  Vector pivot;
  Vector scale;
  double rotation;
  Vector velocity;
  ColorFilter colorFilter;
  ui.Image image;
  Offset acceleration;

  double _currentRotation;
  double maxRotationSpeed = _kRotationSpeed;

  final List<Actor> children = <Actor>[];

  @override
  @mustCallSuper
  void update(Actor root, double millis) {
    if (velocity.x != 0) {
      position.x += velocity.x * millis / 1000;
    }

    if (velocity.y != 0) {
      position.y += velocity.y * millis / 1000;
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

    canvas.translate(position.x, position.y);

    canvas.rotate(_currentRotation ?? 0);

    canvas.scale(scale.x ?? 1, scale.y ?? 1);

    if (image != null) {
      paintImage(
        canvas: canvas,
        rect: Rect.fromCenter(
          center: Offset.zero,
          width: size.x,
          height: size.y,
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
        'position: $position, '
        'size: $size, '
        'velocity: $velocity, '
        'scale: $scale, '
        'rotation: $_currentRotation, '
        'children: $children}';
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
