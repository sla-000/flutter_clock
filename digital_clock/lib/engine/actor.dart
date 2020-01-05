import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:digital_clock/config.dart';
import 'package:digital_clock/engine/math.dart';
import 'package:digital_clock/engine/vector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

abstract class Update {
  void update(Actor root, double millis);
}

abstract class Draw {
  void draw(Canvas canvas);
}

const double _kRotationSpeed = 0.5 * 2 * math.pi; // rad in second

abstract class Actor implements Update, Draw {
  Actor({
    @required this.position,
    @required this.size,
    this.scale,
    this.pivot,
    this.angle,
    this.velocityModule,
    this.velocityAngle,
    this.colorFilter,
    this.image,
  }) {
    scale ??= Vector.one();
    pivot ??= Vector(x: size.x / 2, y: size.y / 2);
    velocityModule ??= 0;
    velocityAngle ??= 0;
    angle ??= velocityAngle;
  }

  Vector position;
  Vector size;
  Vector pivot;
  Vector scale;
  double angle;
  double velocityModule;
  double velocityAngle;
  ColorFilter colorFilter;
  ui.Image image;
  Offset acceleration;

  double maxRotationSpeed = _kRotationSpeed;

  final List<Actor> children = <Actor>[];

  @override
  @mustCallSuper
  void update(Actor root, double millis) {
    if (velocityModule != 0) {
      position.x += velocityModule * math.cos(velocityAngle) * millis / 1000;
      position.y += velocityModule * math.sin(velocityAngle) * millis / 1000;
    }

    angle = nextAngle(angle, velocityAngle, millis);

    final List<Actor> tempActors = List<Actor>.of(children, growable: false);

    for (final Actor actor in tempActors) {
      actor.update(root, millis);
    }
  }

  @override
  void draw(Canvas canvas) {
    canvas.save();

    canvas.translate(position.x, position.y);

    canvas.rotate(angle);

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

  Vector deltaVector(Actor otherActor) {
    return Vector(
      x: position.x - otherActor.position.x,
      y: position.y - otherActor.position.y,
    );
  }

  double distance(Actor other) {
    final double dx = other.position.x - position.x;
    final double dy = other.position.y - position.y;

    return math.sqrt(math.pow(dx, 2) + math.pow(dy, 2));
  }

  double radius() => (size.x * scale.x + size.y * scale.y) / 4;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Actor &&
          runtimeType == other.runtimeType &&
          position == other.position &&
          scale == other.scale &&
          velocityModule == other.velocityModule &&
          velocityAngle == other.velocityAngle;

  @override
  int get hashCode =>
      position.hashCode ^
      scale.hashCode ^
      velocityModule.hashCode ^
      velocityAngle.hashCode;

  @override
  String toString() {
    return 'Actor{position: $position, '
        'size: $size, '
        'velocityModule: $velocityModule, '
        'velocityAngle: $velocityAngle, '
        'scale: $scale, '
        'angle: $angle, '
        'children: $children}';
  }
}
